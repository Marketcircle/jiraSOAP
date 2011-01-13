module JIRA
module RemoteAPI
  # @group Working with Schemes

  # @return [Array<JIRA::NotificationScheme>]
  def get_notification_schemes
    jira_call( 'getNotificationSchemes' ).map { |frag|
      JIRA::NotificationScheme.new_with_xml frag
    }
  end

  # @endgroup
end
end
