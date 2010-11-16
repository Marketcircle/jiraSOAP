# Contains the API defined by Atlassian for the JIRA SOAP service. The JavaDoc
# for the SOAP API is located at http://docs.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/soap/JiraSoapService.html.
# @todo exception handling
# @todo logging
# @todo code refactoring and de-duplication
# @todo break the API down by task, like Apple's developer documentation
# @todo deleteProjectAvatar [target v0.5]
# @todo setProjectAvatar (change to different existing) [target v0.5]
# @todo setNewProjectAvatar (upload new and set it) [target v0.5]
# @todo createProjectRole [v0.6]
# @todo getAvailableActions [target v0.7]
# @todo progressWorkflowAction [target v0.7]
module RemoteAPI
  # XPath constant to get a node containing a response array.
  # This could be used for all responses, but is only used in cases where we
  # cannot use a more blunt XPath expression.
  RESPONSE_XPATH = '/node()[1]/node()[1]/node()[1]/node()[2]'

  # The first method to call; other methods will fail until you are logged in.
  # @param [String] user JIRA user name to login with
  # @param [String] password
  # @return [boolean] true if successful, otherwise an exception is thrown
  def login(user, password)
    response = invoke('soap:login') { |msg|
      msg.add 'soap:in0', user
      msg.add 'soap:in1', password
    }
    # cache now that we know it is safe to do so
    @user       = user
    @auth_token = response.document.xpath('//loginReturn').first.to_s
    true
  end

  # You only need to call this to make an explicit logout; normally, a session
  # will automatically expire after a set time (configured on the server).
  # @return [boolean] true if successful, otherwise false
  def logout
    response = invoke('soap:logout') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath('//logoutReturn').to_boolean
  end

  # @return [[JIRA::Priority]]
  def get_priorities
    response = invoke('soap:getPriorities') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getPrioritiesReturn").map {
      |frag| JIRA::Priority.new frag
    }
  end

  # @return [[JIRA::Resolution]]
  def get_resolutions
    response = invoke('soap:getResolutions') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getResolutionsReturn").map {
      |frag| JIRA::Resolution.new frag
    }
  end

  # @return [[JIRA::Field]]
  def get_custom_fields
    response = invoke('soap:getCustomFields') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getCustomFieldsReturn").map {
      |frag| JIRA::Field.new frag
    }
  end

  # @return [[JIRA::IssueType]]
  def get_issue_types
    response = invoke('soap:getIssueTypes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssueTypesReturn").map {
      |frag| JIRA::IssueType.new frag
    }
  end

  # @return [[JIRA::Status]]
  def get_statuses
    response = invoke('soap:getStatuses') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getStatusesReturn").map {
      |frag| JIRA::Status.new frag
    }
  end

  # @return [[JIRA::NotificationScheme]]
  def get_notification_schemes
    response = invoke('soap:getNotificationSchemes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getNotificationSchemesReturn").map {
      |frag| JIRA::NotificationScheme.new frag
    }
  end

  # @param [String] project_key
  # @return [[JIRA::Version]]
  def get_versions_for_project(project_key)
    response = invoke('soap:getVersions') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getVersionsReturn").map {
      |frag| JIRA::Version.new frag
    }
  end

  # You need to explicitly ask for schemes in order to get them. By
  # default, most project fetching methods purposely leave out all
  # the scheme information as permission schemes can be very large.
  # @param [String] project_key
  # @return [JIRA::Project]
  def get_project_with_key(project_key)
    response = invoke('soap:getProjectByKey') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    JIRA::Project.new response.document.xpath('//getProjectByKeyReturn').first
  end

  # @param [String] user_name
  # @return [JIRA::User]
  def get_user_with_name(user_name)
    response = invoke('soap:getUser') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', user_name
    }
    JIRA::User.new response.document.xpath('//getUserReturn').first
  end

  # Gets you the default avatar image for a project; if you want all
  # the avatars for a project, use {#get_project_avatars_for_key}.
  # @param [String] project_key
  # @return [JIRA::Avatar]
  def get_project_avatar_for_key(project_key)
    response = invoke('soap:getProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    JIRA::Avatar.new response.document.xpath('//getProjectAvatarReturn').first
  end

  # Gets ALL avatars for a given project with this method; if you
  # just want the project avatar, use {#get_project_avatar_for_key}.
  # @param [String] project_key
  # @param [boolean] include_default_avatars
  # @return [[JIRA::Avatar]]
  def get_project_avatars_for_key(project_key, include_default_avatars = false)
    response = invoke('soap:getProjectAvatars') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
      msg.add 'soap:in2', include_default_avatars
    }
    response.document.xpath("#{RESPONSE_XPATH}/getProjectAvatarsReturn").map {
      |frag| JIRA::Avatar.new frag
    }
  end

  # This method is the equivalent of making an advanced search from the
  # web interface.
  #
  # During my own testing, I found that HTTP requests could timeout for really
  # large requests (~2500 results). So I set a more reasonable upper limit;
  # feel free to override it, but be aware of the potential issues.
  #
  # The JIRA::Issue structure does not include any comments or attachments.
  # @param [String] jql_query JQL query as a string
  # @param [Fixnum] max_results limit on number of returned results;
  #  the value may be overridden by the server if max_results is too large
  # @return [[JIRA::Issue]]
  def get_issues_from_jql_search(jql_query, max_results = 2000)
    response = invoke('soap:getIssuesFromJqlSearch') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', jql_query
      msg.add 'soap:in2', max_results
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssuesFromJqlSearchReturn").map {
      |frag| JIRA::Issue.new frag
    }
  end

  # This method can update most, but not all, issue fields. Some limitations
  # are because of how the API is designed, and some are because I have not
  # yet implemented the ability to update fields made of custom objects (things
  # in the JIRA module).
  #
  # Fields known to not update via this method:
  #  - status - use {#progress_workflow_action}
  #  - attachments - use {#add_base64_encoded_attachments_to_issue_with_key}
  #
  # Though JIRA::FieldValue objects have an id field, they do not expect to be
  # given id values. You must use the name of the field you wish to update.
  # @example Usage With A Normal Field
  #  summary        = JIRA::FieldValue.new 'summary', ['My new summary']
  # @example Usage With A Custom Field
  #  custom_field        = JIRA::FieldValue.new 'customfield_10060', ['123456']
  # @example Setting a field to be blank/nil
  #  description = JIRA::FieldValue.new 'description'
  # @example Calling the method to update an issue
  #  jira_service_instance.update_issue 'PROJECT-1', description, custom_field
  # @param [String] issue_key
  # @param [JIRA::FieldValue] *field_values
  # @return [JIRA::Issue]
  def update_issue(issue_key, *field_values)
    response = invoke('soap:updateIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2'  do |submsg|
        field_values.each { |fv| fv.soapify_for submsg }
      end
    }
    JIRA::Issue.new response.document.xpath('//updateIssueReturn').first
  end

  # Some fields will be ignored when an issue is created.
  #  - reporter - you cannot override this value at creation
  #  - resolution
  #  - attachments
  #  - votes
  #  - status
  #  - due date - I think this is a bug in jiraSOAP or JIRA
  #  - environment - I think this is a bug in jiraSOAP or JIRA
  # @param [JIRA::Issue] issue
  # @return [JIRA::Issue]
  def create_issue_with_issue(issue)
    response = invoke('soap:createIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg|
        issue.soapify_for submsg
      end
    }
    JIRA::Issue.new response.document.xpath('//createIssueReturn').first
  end

  # @param [String] issue_key
  # @return [JIRA::Issue]
  def get_issue_with_key(issue_key)
    response = invoke('soap:getIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    JIRA::Issue.new response.document.xpath('//getIssueReturn').first
  end

  # @param [String] issue_id
  # @return [JIRA::Issue]
  def get_issue_with_id(issue_id)
    response = invoke('soap:getIssueById') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_id
    }
    JIRA::Issue.new response.document.xpath('//getIssueByIdReturn').first
  end

  # @param [String] issue_key
  # @return [[JIRA::Attachment]]
  def get_attachments_for_issue_with_key(issue_key)
    response = invoke('soap:getAttachmentsFromIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getAttachmentsFromIssueReturn").map {
      |frag| JIRA::AttachmentMetadata.new frag
    }
  end

  # New versions cannot have the archived bit set and the release date
  # field will ignore the time of day you give it and instead insert
  # the time zone offset as the time of day.
  #
  # Remember that the @release_date field is the tentative release date,
  # so its value is independant of the @released flag.
  #
  # Descriptions do not appear to be included with JIRA::Version objects
  # that SOAP API provides.
  # @param [String] project_key
  # @param [JIRA::Version] version
  # @return [JIRA::Version]
  def add_version_to_project_with_key(project_key, version)
    response = invoke('soap:addVersion') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
      msg.add 'soap:in2' do |submsg| version.soapify_for submsg end
    }
    JIRA::Version.new response.document.xpath('//addVersionReturn').first
  end

  # The archive state can only be set to true for versions that have not been
  # released. However, this is not reflected by the return value of this method.
  # @param [String] project_key
  # @param [String] version_name
  # @param [boolean] state
  # @return [boolean] true if successful, otherwise an exception is thrown
  def set_archive_state_for_version_for_project(project_key, version_name, state)
    response = invoke('soap:archiveVersion') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
      msg.add 'soap:in2', version_name
      msg.add 'soap:in3', state
    }
    true
  end

  # Requires you to set at least a project name, key, and lead.
  # However, it is also a good idea to set other project properties, such as
  # the permission scheme as the default permission scheme can be too
  # restrictive in most cases.
  # @param [JIRA::Project] project
  # @return [JIRA::Project]
  def create_project_with_project(project)
    response = invoke('soap:createProjectFromObject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project.soapify_for submsg end
    }
    JIRA::Project.new response.document.xpath('//createProjectFromObjectReturn').first
  end

  # You can set the release state for a project with this method.
  # @param [String] project_name
  # @param [JIRA::Version] version
  # @return [boolean] true, throws an exception otherwise
  def release_state_for_version_for_project(project_name, version)
    response = invoke('soap:releaseVersion') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_name
      msg.add 'soap:in2' do |submsg| version.soapify_for submsg end
    }
    true
  end

  # The id of the project is the only field that you cannot update. Or, at
  # least the only field I know that you cannot update.
  # @param [JIRA::Project] project
  # @return [JIRA::Project]
  def update_project_with_project(project)
    response = invoke('soap:updateProject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project.soapify_for submsg end
    }
    JIRA::Project.new response.document.xpath('//updateProjectReturn').first
  end

  # It seems that creating a user without any permission groups will trigger
  # an exception on some versions of JIRA. The irony is that this method provides
  # no way to add groups. The good news though, is that the creation will still
  # happen; but the user will have no permissions.
  # @param [String] username
  # @param [String] password
  # @param [String] full_name
  # @param [String] email
  # @return [JIRA::User,nil] depending on your JIRA version, this method may
  #   always raise an exception instead of actually returning anythin
  def create_user(username, password, full_name, email)
    response = invoke('soap:createUser') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', username
      msg.add 'soap:in2', password
      msg.add 'soap:in3', full_name
      msg.add 'soap:in4', email
    }
    JIRA::User.new response.document.xpath('//createUserReturn').first
  end

  # @param [String] username
  # @return [boolean] true if successful, throws an exception otherwise
  def delete_user_with_name(username)
    response = invoke('soap:deleteUser') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', username
    }
    true
  end

  # @param [String] project_id
  # @return [JIRA::Project]
  def get_project_with_id(project_id)
    response = invoke('soap:getProjectById') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_id
    }
    JIRA::Project.new response.document.xpath('//getProjectByIdReturn').first
  end

  # @todo parse the permission scheme
  # Note: this method does not yet include the permission scheme.
  # @param [String] project_id
  # @return [JIRA::Project]
  def get_project_including_schemes_with_id(project_id)
    response = invoke('soap:getProjectWithSchemesById') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_id
    }
    JIRA::Project.new response.document.xpath '//getProjectWithSchemesByIdReturn'
  end

  # @param [String] issue_key
  # @param [JIRA::Comment] comment
  # @return [boolean] true if successful, throws an exception otherwise
  def add_comment_to_issue_with_key(issue_key, comment)
    response = invoke('soap:addComment') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2' do |submsg| comment.soapify_for submsg end
    }
    true
  end

  # @param [String] id
  # @return [JIRA::Comment]
  def get_comment_with_id(id)
    response = invoke('soap:getComment') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', id
    }
    JIRA::Comment.new response.document.xpath('//getCommentReturn').first
  end

  # @param [String] issue_key
  # @return [[JIRA::Comment]]
  def get_comments_for_issue_with_key(issue_key)
    response = invoke('soap:getComments') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getCommentsReturn").map {
      |frag| JIRA::Comment.new frag
    }
  end

  # @param [String] project_name
  # @return [[JIRA::IssueType]]
  def get_issue_types_for_project_with_id(project_id)
    response = invoke('soap:getIssueTypesForProject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_id
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssueTypesForProjectReturn").map {
      |frag| JIRA::IssueType.new frag
    }
  end

  # @param [JIRA::Comment] comment
  # @return [JIRA::Comment]
  def update_comment(comment)
    response = invoke('soap:editComment') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| comment.soapify_for submsg end
    }
    frag = response.document.xpath('//editCommentReturn').first
    JIRA::Comment.new frag
  end

  # @return [[JIRA::IssueType]]
  def get_subtask_issue_types
    response = invoke('soap:getSubTaskIssueTypes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getSubTaskIssueTypesReturn").map {
      |frag| JIRA::IssueType.new frag
    }
  end

  # @param [String] project_id
  # @return [[JIRA::IssueType]]
  def get_subtask_issue_types_for_project_with_id(project_id)
    response = invoke('soap:getSubTaskIssueTypesForProject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_id
    }
    response.document.xpath("#{RESPONSE_XPATH}/getSubtaskIssueTypesForProjectReturn").map {
      |frag| JIRA::IssueType.new frag
    }
  end

  # I have no idea what this method does.
  # @todo find out what this method does
  # @return [boolean] true if successful, throws an exception otherwise
  def refresh_custom_fields
    response = invoke('soap:refreshCustomFields') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    true
  end

  # Retrieves favourite filters for the currently logged in user.
  # @return [[JIRA::Filter]]
  def get_favourite_filters
    response = invoke('soap:getFavouriteFilters') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getFavouriteFiltersReturn").map {
      |frag| JIRA::Filter.new frag
    }
  end

  # @param [String] id
  # @param [Fixnum] max_results
  # @param [Fixnum] offset
  # @return [[JIRA::Issue]]
  def get_issues_from_filter_with_id(id, max_results = 500, offset = 0)
    response = invoke('soap:getIssuesFromFilterWithLimit') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', id
      msg.add 'soap:in2', offset
      msg.add 'soap:in3', max_results
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssuesFromFilterWithLimitReturn").map {
      |frag| JIRA::Issue.new frag
    }
  end

  # @param [String] id
  # @return [Fixnum]
  def get_issue_count_for_filter_with_id(id)
    response = invoke('soap:getIssueCountForFilter') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', id
    }
    response.document.xpath('//getIssueCountForFilterReturn').to_i
  end

  # @todo optimize building the message, try a single pass
  # Expect this method to be slow.
  # @param [String] issue_key
  # @param [[String]] filenames names to put on the files
  # @param [[String]] data base64 encoded data
  # @return [boolean] true if successful, otherwise an exception is thrown
  def add_base64_encoded_attachments_to_issue_with_key(issue_key, filenames, data)
    response = invoke('soap:addBase64EncodedAttachmentsToIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2' do |submsg|
        filenames.each { |filename| submsg.add 'filenames', filename }
      end
      msg.add 'soap:in3' do |submsg|
        data.each { |datum| submsg.add 'base64EncodedData', datum }
      end
    }
    true
  end

  # The @build_date attribute is a Time value, but does not include a time.
  # @return [JIRA::ServerInfo]
  def get_server_info
    response = invoke('soap:getServerInfo') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    JIRA::ServerInfo.new response.document.xpath('//getServerInfoReturn').first
  end

  # @return [JIRA::ServerConfiguration]
  def get_server_configuration
    response = invoke('soap:getConfiguration') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    JIRA::ServerConfiguration.new response.document.xpath('//getConfigurationReturn').first
  end
end
