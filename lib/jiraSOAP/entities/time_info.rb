##
# Simple structure for a time and time zone; only used by JIRA::ServerInfo
# objects, which themselves are only created when {RemoteAPI#get_server_info}
# is called.
class JIRA::TimeInfo < JIRA::Entity

  # @return [Time]
  add_attribute :server_time, 'serverTime', :to_natural_date

  # @return [String] in the form 'America/Toronto'
  add_attribute :timezone, 'timeZoneId', :content

end
