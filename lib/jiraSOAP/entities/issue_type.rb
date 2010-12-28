# Contains all the metadata for an issue type.
class JIRA::IssueType < JIRA::IssueProperty
  add_attributes({ 'subTask' => [:subtask=, :to_boolean] })

  # @return [boolean]  true if the issue type is also a subtask
  attr_accessor :subtask
  alias_method :subtask?, :subtask
end
