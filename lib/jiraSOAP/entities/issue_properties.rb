module JIRA

# Contains all the metadata for a resolution.
class Resolution < JIRA::IssueProperty
  add_attributes({})
end

# Contains all the metadata for an issue's status.
class Status < JIRA::IssueProperty
  add_attributes({})
end

# Contains all the metadata for a priority level.
# @todo change @color to be some kind of hex Fixnum object
class Priority < JIRA::IssueProperty
  add_attributes({ 'color' => [:color=, :to_s] })

  # @return [String] is a hex value
  attr_accessor :color
end

# Contains all the metadata for an issue type.
class IssueType < JIRA::IssueProperty
  add_attributes({ 'subTask' => [:subtask=, :to_boolean] })

  # @return [boolean]  true if the issue type is also a subtask
  attr_accessor :subtask
  alias_method :subtask?, :subtask
end

end
