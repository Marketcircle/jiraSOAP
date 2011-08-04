module JIRA::RemoteAPI

  # @group Issue attributes

  # @return [Array<JIRA::Priority>]
  def priorities
    array_jira_call JIRA::Priority, 'getPriorities'
  end
  deprecate :priorities

  # @return [Array<JIRA::Resolution>]
  def resolutions
    array_jira_call JIRA::Resolution, 'getResolutions'
  end
  deprecate :resolutions

  # @return [Array<JIRA::Field>]
  def custom_fields
    array_jira_call JIRA::Field, 'getCustomFields'
  end
  deprecate :custom_fields

  # @return [Array<JIRA::IssueType>]
  def issue_types
    array_jira_call JIRA::IssueType, 'getIssueTypes'
  end
  deprecate :issue_types

  # @param [String] project_name
  # @return [Array<JIRA::IssueType>]
  def issue_types_for_project_with_id project_id
    array_jira_call JIRA::IssueType, 'getIssueTypesForProject', project_id
  end
  deprecate :issue_types_for_project_with_id

  # @return [Array<JIRA::Status>]
  def statuses
    array_jira_call JIRA::Status, 'getStatuses'
  end
  deprecate :statuses

  # @return [Array<JIRA::IssueType>]
  def subtask_issue_types
    array_jira_call JIRA::IssueType, 'getSubTaskIssueTypes'
  end
  deprecate :subtask_issue_types

  # @param [String] project_id
  # @return [Array<JIRA::IssueType>]
  def subtask_issue_types_for_project_with_id project_id
    array_jira_call JIRA::IssueType, 'getSubTaskIssueTypesForProject', project_id
  end
  deprecate :subtask_issue_types_for_project_with_id

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
