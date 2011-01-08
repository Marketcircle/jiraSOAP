# Only contains basic information about the endpoint server and only used
# by {RemoteAPI#get_server_info}.
class JIRA::ServerInfo < JIRA::Entity
  add_attributes(
    ['baseUrl',     :base_url,     :to_url],
    ['buildDate',   :build_date,   :to_date],
    ['buildNumber', :build_number, :to_i],
    ['edition',     :edition,      :to_s],
    ['version',     :version,      :to_s],
    ['serverTime',  :server_time,  :to_object, JIRA::TimeInfo]
  )
end
