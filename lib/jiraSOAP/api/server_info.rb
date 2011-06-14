module JIRA::RemoteAPI

  # @group Server Information

  ##
  # The @build_date attribute is a Time value, but does not include a time.
  #
  # @return [JIRA::ServerInfo]
  def server_info
    JIRA::ServerInfo.new_with_xml jira_call( 'getServerInfo' )
  end

  # @return [JIRA::ServerConfiguration]
  def server_configuration
    JIRA::ServerConfiguration.new_with_xml jira_call( 'getConfiguration' )
  end

end
