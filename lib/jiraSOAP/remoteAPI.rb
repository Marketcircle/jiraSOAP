module RemoteAPI
  RESPONSE_XPATH = '/node()[1]/node()[1]/node()[1]/node()[2]'

  def login(user, password)
    response = invoke('soap:login') { |msg|
      msg.add 'soap:in0', user
      msg.add 'soap:in1', password
    }
    #TODO: error handling (catch the exception and look at the Response node?)
    #cache now that we know it is safe to do so
    @user       = user
    @auth_token = response.document.xpath('//loginReturn').first.to_s
    true
  end

  def logout
    response = invoke('soap:logout') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath('//logoutReturn').first.to_s == 'true'
  end

  def get_priorities
    response = invoke('soap:getPriorities') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getPrioritiesReturn").map {
      |frag|
      JIRA::Priority.priority_with_xml_fragment frag
    }
  end

  def get_resolutions
    response = invoke('soap:getResolutions') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getResolutionsReturn").map {
      |frag|
      JIRA::Resolution.resolution_with_xml_fragment frag
    }
  end

  def get_custom_fields
    response = invoke('soap:getCustomFields') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getCustomFieldsReturn").map {
      |frag|
      JIRA::Field.field_with_xml_fragment frag
    }
  end

  def get_issue_types
    response = invoke('soap:getIssueTypes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssueTypesReturn").map {
      |frag|
      JIRA::IssueType.issue_type_with_xml_fragment frag
    }
  end

  def get_statuses
    response = invoke('soap:getStatuses') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getStatusesReturn").map {
      |frag|
      JIRA::Status.status_with_xml_fragment frag
    }
  end

  def get_notification_schemes
    response = invoke('soap:getNotificationSchemes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getNotificationSchemesReturn").map {
      |frag|
      JIRA::Scheme.scheme_with_xml_fragment frag
    }
  end

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

  def get_project_with_key(project_key)
    response = invoke('soap:getProjectByKey') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    frag = response.document.xpath '//getProjectByKeyReturn'
    JIRA::Project.project_with_xml_fragment frag
  end

  def get_user_with_name(user_name)
    response = invoke('soap:getUser') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', user_name
    }
    JIRA::User.user_with_xml_fragment response.document.xpath '//getUserReturn'
  end

  def get_project_avatar_for_key(project_key)
    response = invoke('soap:getProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    JIRA::Avatar.avatar_with_xml_fragment response.document.xpath '//getProjectAvatarReturn'
  end

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
# getProjectAvatars
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
