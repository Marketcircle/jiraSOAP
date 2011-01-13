module JIRA
module RemoteAPI
  # @group Working with issue attributes

  # @return [Array<JIRA::Priority>]
  def get_priorities
    jira_call( 'getPriorities' ).map { |frag| JIRA::Priority.new_with_xml frag }
  end

  # @return [Array<JIRA::Resolution>]
  def get_resolutions
    jira_call( 'getResolutions' ).map { |frag| JIRA::Resolution.new_with_xml frag }
  end

  # @return [Array<JIRA::Field>]
  def get_custom_fields
    jira_call( 'getCustomFields' ).map { |frag| JIRA::Field.new_with_xml frag }
  end

  # @return [Array<JIRA::IssueType>]
  def get_issue_types
    jira_call( 'getIssueTypes' ).map { |frag| JIRA::IssueType.new_with_xml frag }
  end

  # @return [Array<JIRA::Status>]
  def get_statuses
    jira_call( 'getStatuses' ).map { |frag| JIRA::Status.new_with_xml frag }
  end

  # @return [Array<JIRA::IssueType>]
  def get_subtask_issue_types
    jira_call( 'getSubTaskIssueTypes' ).map { |frag| JIRA::IssueType.new_with_xml frag }
  end

  # @param [String] project_id
  # @return [Array<JIRA::IssueType>]
  def get_subtask_issue_types_for_project_with_id project_id
    jira_call( 'getSubTaskIssueTypesForProject', project_id ).map { |frag|
      JIRA::IssueType.new_with_xml frag
    }
  end

  # I have no idea what this method does.
  # @todo find out what this method does
  # @return [Boolean] true if no exceptions were raised
  def refresh_custom_fields
    jira_call 'refreshCustomFields'
    true
  end

  # @endgroup
end
end
