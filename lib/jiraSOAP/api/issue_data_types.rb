module JIRA::RemoteAPI

  # @group IssueAttributes

  # @return [Array<JIRA::Priority>]
  def get_priorities
    array_jira_call JIRA::Priority, 'getPriorities'
  end
  alias_method :priorities, :get_priorities

  # @return [Array<JIRA::Resolution>]
  def get_resolutions
    array_jira_call JIRA::Resolution, 'getResolutions'
  end
  alias_method :resolutions, :get_resolutions

  # @return [Array<JIRA::Field>]
  def get_custom_fields
    array_jira_call JIRA::Field, 'getCustomFields'
  end
  alias_method :custom_fields, :get_custom_fields

  # @return [Array<JIRA::IssueType>]
  def get_issue_types
    array_jira_call JIRA::IssueType, 'getIssueTypes'
  end
  alias_method :issue_types, :get_issue_types

  # @return [Array<JIRA::Status>]
  def get_statuses
    array_jira_call JIRA::Status, 'getStatuses'
  end
  alias_method :statuses, :get_statuses

  # @return [Array<JIRA::IssueType>]
  def get_subtask_issue_types
    array_jira_call JIRA::IssueType, 'getSubTaskIssueTypes'
  end
  alias_method :subtask_issue_types, :get_subtask_issue_types

  # @param [String] project_id
  # @return [Array<JIRA::IssueType>]
  def get_subtask_issue_types_for_project_with_id project_id
    array_jira_call JIRA::IssueType, 'getSubTaskIssueTypesForProject', project_id
  end
  alias_method :subtask_issue_types_for_project_with_id, :get_subtask_issue_types_for_project_with_id

  ##
  # I have no idea what this method does.
  #
  # @todo find out what this method does
  # @return [Boolean] true if no exceptions were raised
  def refresh_custom_fields
    jira_call 'refreshCustomFields'
    true
  end

end
