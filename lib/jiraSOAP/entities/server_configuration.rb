# A simple structure that is used by {RemoteAPI#get_server_configuration}.
class JIRA::ServerConfiguration < JIRA::Entity
  add_attributes(
    ['allowExternalUserManagement', :external_user_management_allowed, :to_boolean],
    ['allowAttachments',            :attachments_allowed,              :to_boolean],
    ['allowIssueLinking',           :issue_linking_allowed,            :to_boolean],
    ['allowSubTasks',               :subtasks_allowed,                 :to_boolean],
    ['allowTimeTracking',           :time_tracking_allowed,            :to_boolean],
    ['allowUnassignedIssues',       :unassigned_issues_allowed,        :to_boolean],
    ['allowVoting',                 :voting_allowed,                   :to_boolean],
    ['allowWatching',               :watching_allowed,                 :to_boolean],
    ['timeTrackingDaysPerWeek',     :time_tracking_days_per_week,      :to_i],
    ['timeTrackingHoursPerDay',     :time_tracking_hours_per_day,      :to_i],
    # In case we are using a version of JIRA that misspells 'management'
    ['allowExternalUserManagment',  :external_user_management_allowed, :to_boolean]
  )
end
