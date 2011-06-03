##
# Only contains basic information about the endpoint server and only used
# by {RemoteAPI#get_server_info}.
class JIRA::ServerInfo < JIRA::Entity

  # @return [NSURL,URI::HTTP]
  add_attribute :base_url, 'baseUrl', :to_url

  # @return [Time]
  add_attribute :build_date, 'buildDate', :to_iso_date

  # @return [Number]
  add_attribute :build_number, 'buildNumber', :to_i

  # @return [String]
  add_attribute :edition, 'edition', :content

  # @return [String]
  add_attribute :version, 'version', :content

  # @return [Array<JIRA::TimeInfo>]
  add_attribute :server_time, 'serverTime', [:children_as_object, JIRA::TimeInfo]

end
