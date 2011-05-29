##
# Only contains basic information about the endpoint server and only used
# by {RemoteAPI#get_server_info}.
class JIRA::ServerInfo < JIRA::Entity
  add_attributes(
    ['baseUrl',     :base_url,     :to_url],
    ['buildDate',   :build_date,   :to_iso_date],
    ['buildNumber', :build_number, :to_i],
    ['edition',     :edition,      :content],
    ['version',     :version,      :content],
    ['serverTime',  :server_time,  :children_as_object, JIRA::TimeInfo]
  )
end
