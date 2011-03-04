module JIRA
module RemoteAPI

##
# @todo Find out what I haven't implemented yet
# @todo  RemoteIssue createIssueWithSecurityLevel(String token, Issue rIssue, Long securityLevelId)
module Issues

  ##
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
  # @return [Array<JIRA::Issue>]
  def get_issues_from_jql_search jql_query, max_results = 2000
    array_jira_call JIRA::Issue, 'getIssuesFromJqlSearch', jql_query, max_results
  end

  ##
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
  def update_issue issue_key, *field_values
    response = invoke('soap:updateIssue') { |msg|
      msg.add 'soap:in0', self.auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2' do |submsg|
        field_values.each { |fv| fv.to_soap submsg }
      end
    }
    JIRA::Issue.new_with_xml response.document.element.xpath('//updateIssueReturn').first
  end

  ##
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
  def create_issue_with_issue issue
    JIRA::Issue.new_with_xml jira_call( 'createIssue', issue )
  end

  ##
  # @param [String] issue_key
  # @return [JIRA::Issue]
  def get_issue_with_key issue_key
    JIRA::Issue.new_with_xml jira_call( 'getIssue', issue_key )
  end

  ##
  # @param [String] issue_id
  # @return [JIRA::Issue]
  def get_issue_with_id issue_id
    JIRA::Issue.new_with_xml jira_call( 'getIssueById', issue_id )
  end

  ##
  # @param [String] id
  # @param [Fixnum] max_results
  # @param [Fixnum] offset
  # @return [Array<JIRA::Issue>]
  def get_issues_from_filter_with_id id, max_results = 500, offset = 0
    array_jira_call JIRA::Issue, 'getIssuesFromFilterWithLimit', id, offset, max_results
  end

  ##
  # @param [String] issue_id
  # @return [Time]
  def get_resolution_date_for_issue_with_id issue_id
    jira_call( 'getResolutionDateById', issue_id ).to_iso_date
  end

  ##
  # @param [String] issue_key
  # @return [Time]
  def get_resolution_date_for_issue_with_key issue_key
    jira_call( 'getResolutionDateByKey', issue_key ).to_iso_date
  end

  ##
  # @param [String] issue_Key
  # @return [Boolean]
  def delete_issue_with_key issue_key
    jira_call 'deleteIssue', issue_key
    true
  end

end
end
end
