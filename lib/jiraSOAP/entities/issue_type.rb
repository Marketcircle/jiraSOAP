##
# Contains all the metadata for an issue type.
class JIRA::IssueType < JIRA::IssueProperty
  add_attributes(
    # True if the issue type is also a subtask
    ['subTask', :subtask, :to_boolean]
  )
end
