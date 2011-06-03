##
# Contains all the metadata for an issue type.
class JIRA::IssueType < JIRA::IssueProperty

  # @return [Boolean] True if the issue type is also a subtask
  add_attribute :subtask, 'subTask', :to_boolean
  alias_method :sub_task, :subtask

end
