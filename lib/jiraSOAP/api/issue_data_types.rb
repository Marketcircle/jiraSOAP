module JIRA::RemoteAPI

  # @group Issue attributes

  # @return [Array<JIRA::Priority>]
  def priorities
    array_jira_call JIRA::Priority, 'getPriorities'
  end

  # @return [Array<JIRA::Resolution>]
  def resolutions
    array_jira_call JIRA::Resolution, 'getResolutions'
  end

  # @return [Array<JIRA::Field>]
  def custom_fields
    array_jira_call JIRA::Field, 'getCustomFields'
  end

  # @return [Array<JIRA::IssueType>]
  def issue_types
    array_jira_call JIRA::IssueType, 'getIssueTypes'
  end

  # @param [String] project_id
  # @return [Array<JIRA::IssueType>]
  def issue_types_for_project_with_id project_id
    array_jira_call JIRA::IssueType, 'getIssueTypesForProject', project_id
  end

  # @return [Array<JIRA::Status>]
  def statuses
    array_jira_call JIRA::Status, 'getStatuses'
  end

  # @return [Array<JIRA::IssueType>]
  def subtask_issue_types
    array_jira_call JIRA::IssueType, 'getSubTaskIssueTypes'
  end

  # @param [String] project_id
  # @return [Array<JIRA::IssueType>]
  def subtask_issue_types_for_project_with_id project_id
    array_jira_call JIRA::IssueType, 'getSubTaskIssueTypesForProject', project_id
  end

  ##
  # @todo find out what this method does
  #
  # I have no idea what this method does.
  #
  # @return [Boolean] true if no exceptions were raised
  def refresh_custom_fields
    jira_call 'refreshCustomFields'
    true
  end

end
