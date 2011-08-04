module JIRA::RemoteAPI

  # @group Schemes

  # @return [Array<JIRA::NotificationScheme>]
  def notification_schemes
    array_jira_call JIRA::NotificationScheme, 'getNotificationSchemes'
  end
  deprecate :notification_schemes

  # @return [Array<JIRA::PermissionScheme>]
  def permission_schemes
    array_jira_call JIRA::PermissionScheme, 'getPermissionSchemes'
  end
  deprecate :permission_schemes

end
