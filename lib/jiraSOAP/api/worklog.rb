module JIRA::RemoteAPI

  # @group Worklogs

  ##
  # Adds a worklog to the given issue.
  #
  # @param [String] issue_key
  # @param [JIRA::Worklog] worklog
  def add_worklog_and_auto_adjust_remaining_estimate issue_key, worklog
    JIRA::Worklog.new_with_xml call( 'addWorklogAndAutoAdjustRemainingEstimate', issue_key, worklog ).first
  end

end
