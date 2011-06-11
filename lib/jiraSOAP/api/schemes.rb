module JIRA::RemoteAPI

  # @group Schemes

  # @return [Array<JIRA::NotificationScheme>]
  def notification_schemes
    array_jira_call JIRA::NotificationScheme, 'getNotificationSchemes'
  end
  alias_method :get_notification_schemes, :notification_schemes

  # @return [Array<JIRA::PermissionScheme>]
  def permission_schemes
    array_jira_call JIRA::PermissionScheme, 'getPermissionSchemes'
  end
  alias_method :get_permission_schemes, :permission_schemes

end
