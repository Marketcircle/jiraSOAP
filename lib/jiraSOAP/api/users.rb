module JIRA
module RemoteAPI
  # @group Working with User data

  # @param [String] user_name
  # @return [JIRA::User]
  def get_user_with_name user_name
    response = invoke('soap:getUser') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', user_name
    }
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
  #   always raise an exception instead of actually returning anythin
  def create_user username, password, full_name, email
    response = invoke('soap:createUser') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', username
      msg.add 'soap:in2', password
      msg.add 'soap:in3', full_name
      msg.add 'soap:in4', email
    }
    JIRA::User.new_with_xml response.document.xpath('//createUserReturn').first
  end

  # @param [String] username
  # @return [true]
  def delete_user_with_name username
    invoke('soap:deleteUser') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', username
    }
    true
  end

  # @endgroup
end
end
