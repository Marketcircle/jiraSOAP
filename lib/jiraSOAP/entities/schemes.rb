module JIRA

# @todo complete this class
# Includes a mapping of project specific permission settings.
class PermissionScheme < JIRA::Scheme
  add_attributes({})

  # @return [nil]
  attr_accessor :permission_mappings
end

# Basic metadata about a project's notification scheme.
class NotificationScheme < JIRA::Scheme
  add_attributes({})
end

# Basic metadata about a project's issue security scheme.
class IssueSecurityScheme < JIRA::Scheme
  add_attributes({})
end

end
