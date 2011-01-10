module JIRA
module RemoteAPI
  # @group Getting information about the server

  # The @build_date attribute is a Time value, but does not include a time.
  # @return [JIRA::ServerInfo]
  def get_server_info
    response = invoke('soap:getServerInfo') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    JIRA::ServerInfo.new_with_xml response.document.xpath('//getServerInfoReturn').first
  end

  # @return [JIRA::ServerConfiguration]
  def get_server_configuration
    response = invoke('soap:getConfiguration') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    JIRA::ServerConfiguration.new_with_xml response.document.xpath('//getConfigurationReturn').first
  end

  # @endgroup
end
end
