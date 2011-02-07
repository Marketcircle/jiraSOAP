module JIRA
module RemoteAPI
  # @group Working with Schemes

  # @return [Array<JIRA::NotificationScheme>]
  def get_notification_schemes
    jira_call JIRA::NotificationScheme, 'getNotificationSchemes'
  end

  # @return [Array<JIRA::PermissionScheme>]
  def get_permission_schemes
    jira_call JIRA::PermissionScheme, 'getPermissionSchemes'
  end

  # @endgroup
end
end
