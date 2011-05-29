module JIRA::RemoteAPI

  # @group Users

  # @param [String] user_name
  # @return [JIRA::User]
  def get_user_with_name user_name
    JIRA::User.new_with_xml jira_call( 'getUser', user_name )
  end

  ##
  # It seems that creating a user without any permission groups will trigger
  # an exception on some versions of JIRA. The irony is that this method provides
  # no way to add groups. The good news though, is that the creation will still
  # happen; but the user will have no permissions.
  #
  # @param [String] username
  # @param [String] password
  # @param [String] full_name
  # @param [String] email
  # @return [JIRA::User,nil] depending on your JIRA version, this method may
  #  always raise an exception instead of actually returning anything
  def create_user username, password, full_name, email
    fragment = jira_call( 'createUser', username, password, full_name, email )
    JIRA::User.new_with_xml fragment
  end

  # @param [String] username
  # @return [Boolean] true if successful
  def delete_user_with_name username
    jira_call 'deleteUser', username
    true
  end

  ##
  # @todo test this method
  #
  # @param [JIRA::UserGroup] group
  # @param [JIRA::User] user
  # @return [Boolean] true if successful
  def add_user_to_group group, user
    jira_call 'addUserToGroup', group, user
    true
  end

  ##
  # @todo test this method
  #
  # Create a new user group. You can initialize the group
  # with a user if you wish.
  #
  # @param [String] group_name
  # @param [JIRA::User] user
  # @return [JIRA::UserGroup]
  def create_user_group group_name, user = nil
    jira_call 'createGroup', group_name, user
  end

  ##
  # @todo test this method
  # @todo find out the semantics of swap_group
  #
  # @param [String]
  # @param [String]
  # @return [Boolean] true if successful
  def delete_user_group group_name, swap_group
    jira_call 'deleteGroup', group_name, swap_group
    true
  end

end
