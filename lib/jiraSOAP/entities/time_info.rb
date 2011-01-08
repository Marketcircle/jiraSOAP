# Simple structure for a time and time zone; only used by JIRA::ServerInfo
# objects, which themselves are only created when {RemoteAPI#get_server_info}
# is called.
class JIRA::TimeInfo < JIRA::Entity
  add_attributes(
    ['serverTime', :server_time, :to_date_string],
    # in the form of 'America/Toronto'
    ['timeZoneId', :timezone,    :to_s]
  )
end
