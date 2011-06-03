##
# A simple structure that is used by {RemoteAPI#get_server_configuration}.
class JIRA::ServerConfiguration < JIRA::Entity

  # @return [Boolean]
  add_attribute :external_user_management_allowed, 'allowExternalUserManagement',  :to_boolean

  # @return [Boolean]
  add_attribute :attachments_allowed, 'allowAttachments', :to_boolean

  # @return [Boolean]
  add_attribute :issue_linking_allowed, 'allowIssueLinking', :to_boolean

  # @return [Boolean]
  add_attribute :subtasks_allowed, 'allowSubTasks', :to_boolean

  # @return [Boolean]
  add_attribute :time_tracking_allowed, 'allowTimeTracking', :to_boolean

  # @return [Boolean]
  add_attribute :unassigned_issues_allowed, 'allowUnassignedIssues', :to_boolean

  # @return [Boolean]
  add_attribute :voting_allowed, 'allowVoting', :to_boolean

  # @return [Boolean]
  add_attribute :watching_allowed, 'allowWatching', :to_boolean

  # @return [Number]
  add_attribute :time_tracking_days_per_week, 'timeTrackingDaysPerWeek', :to_i

  # @return [Number]
  add_attribute :time_tracking_hours_per_day, 'timeTrackingHoursPerDay', :to_i

  # @return [Boolean] In case we are using a version of JIRA that misspells 'management'
  add_attribute :external_user_management_allowed, 'allowExternalUserManagment', :to_boolean

end
