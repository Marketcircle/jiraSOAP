module JIRA
module RemoteAPI

##
# @todo Find out what still needs to be implemented
module Schemes

  ##
  # @return [Array<JIRA::NotificationScheme>]
  def get_notification_schemes
    array_jira_call JIRA::NotificationScheme, 'getNotificationSchemes'
  end

  ##
  # @return [Array<JIRA::PermissionScheme>]
  def get_permission_schemes
    array_jira_call JIRA::PermissionScheme, 'getPermissionSchemes'
  end

  ##
  # @todo test this method
  #
  # @param [JIRA::Permission] permission
  # @param [JIRA::UserName] user_name
  # @param [JIRA::PermissionScheme] scheme
  # @return [JIRA::PermissionScheme]
  def add_permission_for_user_to_scheme permission, user_name, scheme
    JIRA::PermissionScheme.new_with_xml jira_call( 'addPermissionTo',
                                                   scheme, permission, user_name
                                                   )
  end

  ##
  # @todo test this method
  #
  # @param [String] name
  # @param [String] description
  # @return [JIRA::PermissionScheme]
  def create_permission_scheme name, description
    JIRA::PermissionScheme.new_with_xml jira_call( 'createPermissionScheme',
                                                   name, description
                                                   )
  end
end
end
end
