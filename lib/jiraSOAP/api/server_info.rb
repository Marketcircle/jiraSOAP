module JIRA::RemoteAPI

  # @group ServerInfos

  ##
  # The @build_date attribute is a Time value, but does not include a time.
  #
  # @return [JIRA::ServerInfo]
  def get_server_info
    JIRA::ServerInfo.new_with_xml jira_call( 'getServerInfo' )
  end
  alias_method :server_info, :get_server_info

  ##
  # @return [JIRA::ServerConfiguration]
  def get_server_configuration
    JIRA::ServerConfiguration.new_with_xml jira_call( 'getConfiguration' )
  end
  alias_method :server_configuration, :get_server_configuration

end
