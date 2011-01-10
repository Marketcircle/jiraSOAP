module JIRA
module RemoteAPI
  # @group Working with issue attributes

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

  # @endgroup
end
end
