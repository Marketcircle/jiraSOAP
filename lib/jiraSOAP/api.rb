# Contains the API defined by Atlassian for the [JIRA SOAP service](http://docs.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/soap/JiraSoapService.html).
#
# There are several cases where this API diverges from the one defined by
# Atlassian; most notably, this API tries to be more idomatically Ruby by using
# snake case for method names.
# @todo logging
# @todo code refactoring and de-duplication
# @todo break the API down by task, like Apple's developer documentation;
#  I can break the tasks down by CRUD or by what they affect, or both
# @todo progressWorkflowAction and friends [target v0.7]
module RemoteAPI

  # XPath constant to get a node containing a response array.
  # This could be used for all responses, but is only used in cases where we
  # cannot use a more blunt XPath expression.
  RESPONSE_XPATH = '/node()[1]/node()[1]/node()[1]/node()[2]'

  # The first method to call; other methods will fail until you are logged in.
  # @param [String] user JIRA user name to login with
  # @param [String] password
  # @return [true]
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
  # @return [true,false] true if successful, otherwise false
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
      |frag| JIRA::Priority.new_with_xml frag
    }
  end

  # @return [[JIRA::Resolution]]
  def get_resolutions
    response = invoke('soap:getResolutions') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getResolutionsReturn").map {
      |frag| JIRA::Resolution.new_with_xml frag
    }
  end

  # @return [[JIRA::Field]]
  def get_custom_fields
    response = invoke('soap:getCustomFields') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getCustomFieldsReturn").map {
      |frag| JIRA::Field.new_with_xml frag
    }
  end

  # @return [[JIRA::IssueType]]
  def get_issue_types
    response = invoke('soap:getIssueTypes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssueTypesReturn").map {
      |frag| JIRA::IssueType.new_with_xml frag
    }
  end

  # @return [[JIRA::Status]]
  def get_statuses
    response = invoke('soap:getStatuses') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getStatusesReturn").map {
      |frag| JIRA::Status.new_with_xml frag
    }
  end

  # @return [[JIRA::NotificationScheme]]
  def get_notification_schemes
    response = invoke('soap:getNotificationSchemes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getNotificationSchemesReturn").map {
      |frag| JIRA::NotificationScheme.new_with_xml frag
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
      |frag| JIRA::Version.new_with_xml frag
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
    JIRA::Project.new_with_xml response.document.xpath('//getProjectByKeyReturn').first
  end

  # @param [String] user_name
  # @return [JIRA::User]
  def get_user_with_name(user_name)
    response = invoke('soap:getUser') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', user_name
    }
    JIRA::User.new_with_xml response.document.xpath('//getUserReturn').first
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
    JIRA::Avatar.new_with_xml response.document.xpath('//getProjectAvatarReturn').first
  end

  # Gets ALL avatars for a given project with this method; if you
  # just want the project avatar, use {#get_project_avatar_for_key}.
  # @param [String] project_key
  # @param [true,false] include_default_avatars
  # @return [[JIRA::Avatar]]
  def get_project_avatars_for_key(project_key, include_default_avatars = false)
    response = invoke('soap:getProjectAvatars') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
      msg.add 'soap:in2', include_default_avatars
    }
    response.document.xpath("#{RESPONSE_XPATH}/getProjectAvatarsReturn").map {
      |frag| JIRA::Avatar.new_with_xml frag
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
      |frag| JIRA::Issue.new_with_xml frag
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
    JIRA::Issue.new_with_xml response.document.xpath('//updateIssueReturn').first
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
    JIRA::Issue.new_with_xml response.document.xpath('//createIssueReturn').first
  end

  # @param [String] issue_key
  # @return [JIRA::Issue]
  def get_issue_with_key(issue_key)
    response = invoke('soap:getIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    JIRA::Issue.new_with_xml response.document.xpath('//getIssueReturn').first
  end

  # @param [String] issue_id
  # @return [JIRA::Issue]
  def get_issue_with_id(issue_id)
    response = invoke('soap:getIssueById') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_id
    }
    JIRA::Issue.new_with_xml response.document.xpath('//getIssueByIdReturn').first
  end

  # @param [String] issue_key
  # @return [[JIRA::Attachment]]
  def get_attachments_for_issue_with_key(issue_key)
    response = invoke('soap:getAttachmentsFromIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getAttachmentsFromIssueReturn").map {
      |frag| JIRA::AttachmentMetadata.new_with_xml frag
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
    JIRA::Version.new_with_xml response.document.xpath('//addVersionReturn').first
  end

  # The archive state can only be set to true for versions that have not been
  # released. However, this is not reflected by the return value of this method.
  # @param [String] project_key
  # @param [String] version_name
  # @param [true,false] state
  # @return [true]
  def set_archive_state_for_version_for_project(project_key, version_name, state)
    invoke('soap:archiveVersion') { |msg|
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
    JIRA::Project.new_with_xml response.document.xpath('//createProjectFromObjectReturn').first
  end

  # You can set the release state for a project with this method.
  # @param [String] project_name
  # @param [JIRA::Version] version
  # @return [true]
  def release_state_for_version_for_project(project_name, version)
    invoke('soap:releaseVersion') { |msg|
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
    JIRA::Project.new_with_xml response.document.xpath('//updateProjectReturn').first
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
    JIRA::User.new_with_xml response.document.xpath('//createUserReturn').first
  end

  # @param [String] username
  # @return [true]
  def delete_user_with_name(username)
    invoke('soap:deleteUser') { |msg|
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
    JIRA::Project.new_with_xml response.document.xpath('//getProjectByIdReturn').first
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
    JIRA::Project.new_with_xml response.document.xpath('//getProjectWithSchemesByIdReturn').first
  end

  # @param [String] issue_key
  # @param [JIRA::Comment] comment
  # @return [true]
  def add_comment_to_issue_with_key(issue_key, comment)
    invoke('soap:addComment') { |msg|
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
    JIRA::Comment.new_with_xml response.document.xpath('//getCommentReturn').first
  end

  # @param [String] issue_key
  # @return [[JIRA::Comment]]
  def get_comments_for_issue_with_key(issue_key)
    response = invoke('soap:getComments') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getCommentsReturn").map {
      |frag| JIRA::Comment.new_with_xml frag
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
      |frag| JIRA::IssueType.new_with_xml frag
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
    JIRA::Comment.new_with_xml frag
  end

  # @return [[JIRA::IssueType]]
  def get_subtask_issue_types
    response = invoke('soap:getSubTaskIssueTypes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getSubTaskIssueTypesReturn").map {
      |frag| JIRA::IssueType.new_with_xml frag
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
      |frag| JIRA::IssueType.new_with_xml frag
    }
  end

  # I have no idea what this method does.
  # @todo find out what this method does
  # @return [true]
  def refresh_custom_fields
    invoke('soap:refreshCustomFields') { |msg|
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
      |frag| JIRA::Filter.new_with_xml frag
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
      |frag| JIRA::Issue.new_with_xml frag
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
  # @return [true]
  def add_base64_encoded_attachments_to_issue_with_key(issue_key, filenames, data)
    invoke('soap:addBase64EncodedAttachmentsToIssue') { |msg|
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
    JIRA::ServerInfo.new_with_xml response.document.xpath('//getServerInfoReturn').first
  end

  # @return [JIRA::ServerConfiguration]
  def get_server_configuration
    response = invoke('soap:getConfiguration') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    JIRA::ServerConfiguration.new_with_xml response.document.xpath('//getConfigurationReturn').first
  end

  # @note This will not fill in JIRA::Scheme data for the projects.
  # @return [[JIRA::Project]]
  def get_projects_without_schemes
    response = invoke('soap:getProjectsNoSchemes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getProjectsNoSchemesReturn").map {
      |frag| JIRA::Project.new_with_xml frag
    }
  end

  # @param [#to_s] issue_id
  # @return [Time]
  def get_resolution_date_for_issue_with_id issue_id
    response = invoke('soap:getResolutionDateById') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_id
    }
    response.document.xpath('//getResolutionDateByIdReturn').to_date
  end

  # @param [String] issue_key
  # @return [Time]
  def get_resolution_date_for_issue_with_key issue_key
    response = invoke('soap:getResolutionDateByKey') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    response.document.xpath('//getResolutionDateByKeyReturn').to_date
  end

  # @param [String] project_key
  # @return [true]
  def delete_project_with_key project_key
    invoke('soap:deleteProject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    true
  end

  # @todo add tests for this method
  # @note You cannot delete the system avatar
  # @note You need project administration permissions to delete an avatar
  # @param [#to_s] avatar_id
  # @return [true]
  def delete_project_avatar_with_id avatar_id
    invoke('soap:deleteProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', avatar_id
    }
    true
  end

  # @note You need project administration permissions to edit an avatar
  # @note JIRA does not care if the avatar_id is valid
  # Change the project avatar to another existing avatar. If you want to
  # upload a new avatar and set it to be the new project avatar use
  # {#set_new_project_avatar} instead.
  # @return [true]
  def set_project_avatar_for_project_with_key project_key, avatar_id
    invoke('soap:setProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
      msg.add 'soap:in2', avatar_id
    }
    true
  end

  # @note You need project administration permissions to edit an avatar
  # Use this method to create a new custom avatar for a project and set it
  # to be current avatar for the project.
  #
  # The image, provided as base64 encoded data, should be a 48x48 pixel square.
  # If the image is larger, the top left 48 pixels are taken, if it is smaller
  # then it will be upscaled to 48 pixels.
  # The small version of the avatar image (16 pixels) is generated
  # automatically.
  # If you want to switch a project avatar to an avatar that already exists on
  # the system then use {#set_project_avatar_for_project_with_key} instead.
  # @param [String] project_key
  # @param [String] mime_type
  # @param [#to_s] base64_image
  # @return [true]
  def set_new_project_avatar_for_project_with_key project_key, mime_type, base64_image
    invoke('soap:setNewProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
      msg.add 'soap:in2', mime_type
      msg.add 'soap:in3', base64_image
    }
    true
  end

  # @return [[JIRA::ProjectRole]]
  def get_project_roles
    response = invoke('soap:getProjectRoles') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getProjectRolesReturn").map {
      |frag| JIRA::ProjectRole.new_with_xml frag
    }
  end

  # @param [#to_s] role_id
  # @return [JIRA::ProjectRole]
  def get_project_role_with_id role_id
    response = invoke('soap:getProjectRole') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', role_id
    }
    JIRA::ProjectRole.new_with_xml response.document.xpath('//getProjectRoleReturn').first
  end

  # @param [JIRA::ProjectRole] project_role
  # @return [JIRA::ProjectRole] the role that was created
  def create_project_role_with_role project_role
    response = invoke('soap:createProjectRole') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project_role.soapify_for submsg end
    }
    JIRA::ProjectRole.new_with_xml response.document.xpath('//createProjectRoleReturn').first
  end

  # @note JIRA 4.0 returns an exception if the name already exists
  # Returns true if the name does not exist.
  # @param [String] project_role_name
  # @return [true,false]
  def project_role_name_unique? project_role_name
    response = invoke('soap:isProjectRoleNameUnique') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_role_name
    }
    response.document.xpath('//isProjectRoleNameUniqueReturn').to_boolean
  end

  # @note the confirm argument appears to do nothing (at least on JIRA 4.0)
  # @param [JIRA::ProjectRole] project_role
  # @param [true,false] confirm
  # @return [true]
  def delete_project_role project_role, confirm = true
    invoke('soap:deleteProjectRole') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project_role.soapify_for submsg end
      msg.add 'soap:in2', confirm
    }
    true
  end

  # @note JIRA 4.0 will not update project roles, it will instead throw
  #  an exception telling you that the project role already exists
  # @param [JIRA::ProjectRole] project_role
  # @return [JIRA::ProjectRole] the role after the update
  def update_project_role_with_role project_role
    response = invoke('soap:updateProjectRole') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project_role.soapify_for submsg end
    }
    JIRA::ProjectRole.new_with_xml response.document.xpath('//updateProjectRoleReturn').first
  end

end
