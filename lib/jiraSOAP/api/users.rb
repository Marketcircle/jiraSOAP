module JIRA
module RemoteAPI
  # @group Working with User data

  # @param [String] user_name
  # @return [JIRA::User]
  def get_user_with_name user_name
    response = jira_call 'getUser', user_name
    JIRA::User.new_with_xml response.document.xpath('//getUserReturn').first
  end

  # It seems that creating a user without any permission groups will trigger
  # an exception on some versions of JIRA. The irony is that this method provides
  # no way to add groups. The good news though, is that the creation will still
  # happen; but the user will have no permissions.
  # @param [String] username
  # @param [String] password
  # @param [String] full_name
  # @param [String] email
  # @return [JIRA::User,nil] depending on your JIRA version, this method may
  #  always raise an exception instead of actually returning anythin
  def create_user username, password, full_name, email
    response = jira_call 'createUser', username, password, full_name, email
    JIRA::User.new_with_xml response.document.xpath('//createUserReturn').first
  end

  # @param [String] username
  # @return [Boolean] true if successful
  def delete_user_with_name username
    jira_call 'deleteUser', username
    true
  end

  # @endgroup
end
end
