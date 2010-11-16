module JIRA

# Only contains basic information about the endpoint server and only used
# by {RemoteAPI#get_server_info}.
class ServerInfo
  # @return [URL]
  attr_reader :base_url
  # @return [Time]
  attr_reader :build_date
  # @return [Fixnum]
  attr_reader :build_number
  # @return [String]
  attr_reader :edition
  # @return [JIRA::TimeInfo]
  attr_reader :server_time
  # @return [String]
  attr_reader :version

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @build_date, @build_number, @base_url, @edition, @version, @server_time =
      frag.nodes( ['buildDate',   :to_date],
                  ['buildNumber', :to_i],
                  ['baseUrl',     :to_url],
                  ['edition',     :to_s],
                  ['version',     :to_s],
                  ['serverTime',  :to_object, JIRA::TimeInfo] )
  end
end

# Simple structure for a time and time zone; only used by JIRA::ServerInfo
# objects, which themselves are only created when {RemoteAPI#get_server_info}
# is called.
class TimeInfo
  # @return [Time]
  attr_reader :server_time
  # @return [String] in the form of 'America/Toronto'
  attr_reader :timezone

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @server_time, @timezone =
      frag.nodes ['serverTime', :to_date], ['timeZoneId', :to_s]
  end
end

# A simple structure that is used by {RemoteAPI#get_server_configuration}.
class ServerConfiguration
  # @return [boolean]
  attr_reader :attachments_allowed
  # @return [boolean]
  attr_reader :external_user_management_allowed
  # @return [boolean]
  attr_reader :issue_linking_allowed
  # @return [boolean]
  attr_reader :subtasks_allowed
  # @return [boolean]
  attr_reader :time_tracking_allowed
  # @return [boolean]
  attr_reader :unassigned_issues_allowed
  # @return [boolean]
  attr_reader :voting_allowed
  # @return [boolean]
  attr_reader :watching_allowed
  # @return [Fixnum]
  attr_reader :time_tracking_days_per_week
  # @return [Fixnum]
  attr_reader :time_tracking_hours_per_day

  def attachments_allowed?; @attachments_allowed; end
  def external_user_management_allowed?; @external_user_management_allowed; end
  def issue_linking_allowed?; @issue_linking_allowed; end
  def subtasks_allowed?; @subtasks_allowed; end
  def time_tracking_allowed?; @time_tracking_allowed; end
  def unassigned_issues_allowed?; @unassigned_issues_allowed; end
  def voting_allowed?; @voting_allowed; end
  def watching_allowed?; @watching_allowed; end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @external_user_management_allowed, @attachments_allowed,
    @issue_linking_allowed,            @subtasks_allowed,
    @time_tracking_allowed,            @unassigned_issues_allowed,
    @voting_allowed,                   @watching_allowed,
    @time_tracking_days_per_week,      @time_tracking_hours_per_day =
      frag.nodes( ['allowExternalUserManagement', :to_boolean],
                  ['allowAttachments',            :to_boolean],
                  ['allowIssueLinking',           :to_boolean],
                  ['allowSubTasks',               :to_boolean],
                  ['allowTimeTracking',           :to_boolean],
                  ['allowUnassignedIssues',       :to_boolean],
                  ['allowVoting',                 :to_boolean],
                  ['allowWatching',               :to_boolean],
                  ['timeTrackingDaysPerWeek',     :to_i],
                  ['timeTrackingHoursPerDay',     :to_i] )
  end
end

end
