##
# Contains all the metadata for an issue type.
class JIRA::IssueType < JIRA::IssueProperty

  ##
  # True if the issue type is also a subtask
  #
  # @return [Boolean]
  add_attribute :subtask, 'subTask', :to_boolean
  alias_attribute :sub_task, :subtask

end
