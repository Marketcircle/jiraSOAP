# @todo complete this class
# Includes a mapping of project specific permission settings.
class JIRA::PermissionScheme < JIRA::Scheme
  add_attributes({})

  # @return [nil]
  attr_accessor :permission_mappings
end
