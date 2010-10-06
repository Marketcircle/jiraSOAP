# Contains the API defined by Atlassian for the JIRA SOAP service. The JavaDoc
# for the SOAP API is located at http://docs.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/soap/JiraSoapService.html.
#@todo exception handling
#@todo code refactoring and de-duplication
module RemoteAPI
  #XPath constant to get a node containing a response array.
  #This could be used for all responses, but is only used in cases where we
  #cannot use a more blunt XPath expression.
  RESPONSE_XPATH = '/node()[1]/node()[1]/node()[1]/node()[2]'

  #The first method to call. No other method will work unless you are logged in.
  #@param [String] user JIRA user name to login with
  #@param [String] password
  #@return [boolean] true if successful, otherwise false
  def login(user, password)
    response = invoke('soap:login') { |msg|
      msg.add 'soap:in0', user
      msg.add 'soap:in1', password
    }
    #cache now that we know it is safe to do so
    @user       = user
    @auth_token = response.document.xpath('//loginReturn').first.to_s
    true
  end

  #You only need to call this to make an exlicit logout; normally, a session
  #willautomatically expire after a set time (configured on the server).
  #@return [boolean] true if successful, otherwise false
  def logout
    response = invoke('soap:logout') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath('//logoutReturn').first.to_s == 'true'
  end

  #Get the global listing for types of priorities.
  #@return [[JIRA::Priority]]
  def get_priorities
    response = invoke('soap:getPriorities') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getPrioritiesReturn").map {
      |frag|
      JIRA::Priority.priority_with_xml_fragment frag
    }
  end

  #Get the global listing for types of resolutions.
  #@return [[JIRA::Resolution]]
  def get_resolutions
    response = invoke('soap:getResolutions') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getResolutionsReturn").map {
      |frag|
      JIRA::Resolution.resolution_with_xml_fragment frag
    }
  end

  #Get the global listing for types of custom fields.
  #@return [[JIRA::Field]]
  def get_custom_fields
    response = invoke('soap:getCustomFields') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getCustomFieldsReturn").map {
      |frag|
      JIRA::Field.field_with_xml_fragment frag
    }
  end

  #Get the global listing for types of issues.
  #@return [[JIRA::IssueType]]
  def get_issue_types
    response = invoke('soap:getIssueTypes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssueTypesReturn").map {
      |frag|
      JIRA::IssueType.issue_type_with_xml_fragment frag
    }
  end

  #Get the global listing of status type.
  #@return [[JIRA::Status]]
  def get_statuses
    response = invoke('soap:getStatuses') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getStatusesReturn").map {
      |frag|
      JIRA::Status.status_with_xml_fragment frag
    }
  end

  #Get the global listing for notification schemes.
  #@return [[JIRA::Scheme]]
  def get_notification_schemes
    response = invoke('soap:getNotificationSchemes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getNotificationSchemesReturn").map {
      |frag|
      JIRA::Scheme.scheme_with_xml_fragment frag
    }
  end

  #Get all the versions associated with a project.
  #@param [String] project_key
  #@return [[JIRA::Version]]
  def get_versions_for_project(project_key)
    response = invoke('soap:getVersions') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getVersionsReturn").map {
      |frag|
      JIRA::Version.version_with_xml_fragment frag
    }
  end

  #Get the information for a project with a given key.
  #@param [String] project_key
  #@return [JIRA::Project]
  def get_project_with_key(project_key)
    response = invoke('soap:getProjectByKey') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    frag = response.document.xpath '//getProjectByKeyReturn'
    JIRA::Project.project_with_xml_fragment frag
  end

  #This will only give you basic information about a user.
  #@param [String] user_name
  #@return [JIRA::User]
  def get_user_with_name(user_name)
    response = invoke('soap:getUser') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', user_name
    }
    JIRA::User.user_with_xml_fragment response.document.xpath '//getUserReturn'
  end

  #Gives you the default avatar image for a project; if you want all
  #the avatars for a project, use {#get_project_avatars_for_key}.
  #@param [String] project_key
  #@return [JIRA::Avatar]
  def get_project_avatar_for_key(project_key)
    response = invoke('soap:getProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    JIRA::Avatar.avatar_with_xml_fragment response.document.xpath '//getProjectAvatarReturn'
  end

  #Gives ALL avatars for a given project use this method; if you
  #just want the default avatar, use {#get_project_avatar_for_key}.
  #@param [String] project_key
  #@return [[JIRA::Avatar]]
  def get_project_avatars_for_key(project_key)
    response = invoke('soap:getProjectAvatars') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getProjectAvatarsReturn").map {
      |frag|
      JIRA::Avatar.avatar_with_xml_fragment frag
    }
  end

  #This method is the equivalent of making an advanced search from the
  #web interface.
  #@param [String] jql_query JQL query as a string
  #@param [Fixnum] max_results limit on number of returned results;
  #  the value may be overridden by the server if max_results is too large
  #@return [[JIRA::Issue]]
  def get_issues_from_jql_search(jql_query, max_results = 500)
    response = invoke('soap:getIssuesFromJqlSearch') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', jql_query
      msg.add 'soap:in2', max_results
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssuesFromJqlSearchReturn").map {
      |frag|
      JIRA::Issue.issue_with_xml_fragment frag
    }
  end

  #This method can update most, but not all, issue fields.
  #
  #Fields known to not update via this method:
  #  - status - use {#progress_workflow_action}
  #  - attachments - use {#add_base64_encoded_attachment_to_issue}
  #
  #Though JIRA::FieldValue objects have an id field, they do not expect
  #to be given id values. You must use the name of the field you wish to update.
  #@example Usage With A Normal Field
  #  summary        = JIRA::FieldValue.new
  #  summary.id     = 'summary'
  #  summary.values = ['My new summary']
  #@example Usage With A Custom Field
  #  custom_field        = JIRA::FieldValue.new
  #  custom_field.id     = 'customfield_10060'
  #  custom_field.values = ['123456']
  #@example Setting a field to be blank/nil
  #  description = JIRA::FieldValue.field_value_with_nil_values 'description'
  #@example Calling the method to update an issue
  #  jira_service_instance.update_issue 'PROJECT-1', description, custom_field
  #@param [String] issue_key
  #@param [JIRA::FieldValue] *field_values
  #@return [JIRA::Issue]
  def update_issue(issue_key, *field_values)
    response = invoke('soap:updateIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2'  do |submsg|
        field_values.each { |fv| fv.soapify_for submsg }
      end
    }
    frag = response.document.xpath '//updateIssueReturn'
    JIRA::Issue.issue_with_xml_fragment frag
  end

  #Some fields will be ignored when an issue is created:
  #  - reporter - you cannot override this value at creation
  #  - due date - I think this is a bug in jiraSOAP or JIRA
  #  - attachments
  #  - votes
  #  - status
  #  - resolution
  #  - environment - I think this is a bug in jiraSOAP or JIRA
  #@param [JIRA::Issue] issue
  #@return [JIRA::Issue]
  def create_issue_with_issue(issue)
    response = invoke('soap:createIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg|
        issue.soapify_for submsg
      end
    }
    frag = response.document.xpath '//createIssueReturn'
    JIRA::Issue.issue_with_xml_fragment frag
  end
end

#TODO: next block of useful methods
# addBase64EncodedAttachmentsToIssue
# addComment
# addVersion
# archiveVersion
# createProject
# createProjectRole
# createUser
# deleteProjectAvatar
# deleteUser
# editComment
# getAttachmentsFromIssue
# getAvailableActions
# getComment
# getComments
# getComponents
# getFavouriteFilters
# getIssue
# getIssueById
# getIssueCountForFilter
# getIssuesFromFilterWithLimit
# getIssuesFromTextSearchWithLimit
# getIssueTypesForProject
# getProjectById
# getServerInfo
# getSubTaskIssueTypes
# getSubTaskIssueTypesForProject
# progressWorkflowAction
# refreshCustomFields
# releaseVersion
# setProjectAvatar (change to different existing)
# setNewProjectAvatar (upload new and set it)
# updateProject
# progressWorkflowAction
