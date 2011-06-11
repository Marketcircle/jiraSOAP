module JIRA::RemoteAPI

  # @group Schemes

  # @return [Array<JIRA::NotificationScheme>]
  def get_notification_schemes
    array_jira_call JIRA::NotificationScheme, 'getNotificationSchemes'
  end

  # @return [Array<JIRA::PermissionScheme>]
  def get_permission_schemes
    array_jira_call JIRA::PermissionScheme, 'getPermissionSchemes'
  end

end
