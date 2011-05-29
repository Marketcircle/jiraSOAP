module JIRA::RemoteAPI

  # @group Working with Worklogs

  ##
  # Adds a worklog to the given issue.
  #
  # @param [String] issue_key
  # @param [JIRA::Worklog] worklog
  def add_worklog_and_auto_adjust_remaining_estimate issue_key, worklog
    JIRA::Worklog.new_with_xml call( 'addWorklogAndAutoAdjustRemainingEstimate', issue_key, worklog ).first
  end

  # RemoteWorklog	addWorklogAndRetainRemainingEstimate(java.lang.String token, java.lang.String issueKey, RemoteWorklog remoteWorklog)
  #          Adds a worklog to the given issue but leaves the issue's remaining estimate field unchanged.
  # RemoteWorklog	addWorklogWithNewRemainingEstimate(java.lang.String token, java.lang.String issueKey, RemoteWorklog remoteWorklog, java.lang.String newRemainingEstimate)
  #          Adds a worklog to the given issue and sets the issue's remaining estimate field to the given value.

end
