module JIRA
module RemoteAPI
  # @group Working with Schemes

  # @return [Array<JIRA::NotificationScheme>]
  def get_notification_schemes
    jira_call JIRA::NotificationScheme, 'getNotificationSchemes'
  end

  # @endgroup
end
end
