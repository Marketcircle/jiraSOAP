module JIRA
module RemoteAPI
  # @group Working with issue attributes

  # @return [Array<JIRA::Priority>]
  def get_priorities
    jira_call JIRA::Priority, 'getPriorities'
  end

  # @return [Array<JIRA::Resolution>]
  def get_resolutions
    jira_call JIRA::Resolution, 'getResolutions'
  end

  # @return [Array<JIRA::Field>]
  def get_custom_fields
    jira_call JIRA::Field, 'getCustomFields'
  end

  # @return [Array<JIRA::IssueType>]
  def get_issue_types
    jira_call JIRA::IssueType, 'getIssueTypes'
  end

  # @return [Array<JIRA::Status>]
  def get_statuses
    jira_call JIRA::Status, 'getStatuses'
  end

  # @return [Array<JIRA::IssueType>]
  def get_subtask_issue_types
    jira_call JIRA::IssueType, 'getSubTaskIssueTypes'
  end

  # @param [String] project_id
  # @return [Array<JIRA::IssueType>]
  def get_subtask_issue_types_for_project_with_id project_id
    jira_call JIRA::IssueType, 'getSubTaskIssueTypesForProject', project_id
  end

  # I have no idea what this method does.
  # @todo find out what this method does
  # @return [Boolean] true if no exceptions were raised
  def refresh_custom_fields
    call 'refreshCustomFields'
    true
  end

  # @endgroup
end
end
