module JIRA


# Simple structure for a time and time zone; only used by JIRA::ServerInfo
# objects, which themselves are only created when {RemoteAPI#get_server_info}
# is called.
class TimeInfo < JIRA::Entity

  @attributes = {
    'serverTime' => [:server_time=, :to_string_date],
    'timeZoneId' => [:timezone=,    :to_s]
  }

  # @return [Time]
  attr_accessor :server_time

  # @return [String] in the form of 'America/Toronto'
  attr_accessor :timezone

end


# Only contains basic information about the endpoint server and only used
# by {RemoteAPI#get_server_info}.
class ServerInfo < JIRA::Entity

  @attributes = {
    'baseUrl'     => [:base_url=,     :to_url],
    'buildDate'   => [:build_date=,   :to_date],
    'buildNumber' => [:build_number=, :to_i],
    'edition'     => [:edition=,      :to_s],
    'version'     => [:version=,      :to_s],
    'serverTime'  => [:server_time=,  :to_object, JIRA::TimeInfo]
  }

  # @return [URL]
  attr_accessor :base_url

  # @return [Time]
  attr_accessor :build_date

  # @return [Fixnum]
  attr_accessor :build_number

  # @return [String]
  attr_accessor :edition

  # @return [String]
  attr_accessor :version

  # @return [JIRA::TimeInfo]
  attr_accessor :server_time

end


# A simple structure that is used by {RemoteAPI#get_server_configuration}.
class ServerConfiguration < JIRA::Entity

  @attributes = {
    'allowExternalUserManagement' => [:external_user_management_allowed=, :to_boolean],
    'allowAttachments'            => [:attachments_allowed=,              :to_boolean],
    'allowIssueLinking'           => [:issue_linking_allowed=,            :to_boolean],
    'allowSubTasks'               => [:subtasks_allowed=,                 :to_boolean],
    'allowTimeTracking'           => [:time_tracking_allowed=,            :to_boolean],
    'allowUnassignedIssues'       => [:unassigned_issues_allowed=,        :to_boolean],
    'allowVoting'                 => [:voting_allowed=,                   :to_boolean],
    'allowWatching'               => [:watching_allowed=,                 :to_boolean],
    'timeTrackingDaysPerWeek'     => [:time_tracking_days_per_week=,      :to_i],
    'timeTrackingHoursPerDay'     => [:time_tracking_hours_per_day=,      :to_i],

    # in case we are using a version of JIRA that misspells 'management'
    'allowExternalUserManagment'  => [:external_user_management_allowed=, :to_boolean]
  }

  # @return [boolean]
  attr_accessor :attachments_allowed
  alias_method :attachments_allowed?, :attachments_allowed

  # @return [boolean]
  attr_accessor :external_user_management_allowed
  alias_method :external_user_management_allowed?, :external_user_management_allowed

  # @return [boolean]
  attr_accessor :issue_linking_allowed
  alias_method :issue_linking_allowed?, :issue_linking_allowed

  # @return [boolean]
  attr_accessor :subtasks_allowed
  alias_method :subtasks_allowed?, :subtasks_allowed

  # @return [boolean]
  attr_accessor :time_tracking_allowed
  alias_method :time_tracking_allowed?, :time_tracking_allowed

  # @return [boolean]
  attr_accessor :unassigned_issues_allowed
  alias_method :unassigned_issues_allowed?, :unassigned_issues_allowed

  # @return [boolean]
  attr_accessor :voting_allowed
  alias_method :voting_allowed?, :voting_allowed

  # @return [boolean]
  attr_accessor :watching_allowed
  alias_method :watching_allowed?, :watching_allowed

  # @return [Fixnum]
  attr_accessor :time_tracking_days_per_week

  # @return [Fixnum]
  attr_accessor :time_tracking_hours_per_day

end

end
