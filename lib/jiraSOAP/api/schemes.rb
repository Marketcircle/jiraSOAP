module JIRA
module RemoteAPI
  # @group Working with Schemes

  # @return [[JIRA::NotificationScheme]]
  def get_notification_schemes
    response = invoke('soap:getNotificationSchemes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getNotificationSchemesReturn").map {
      |frag| JIRA::NotificationScheme.new_with_xml frag
    }
  end

  # @endgroup
end
end
