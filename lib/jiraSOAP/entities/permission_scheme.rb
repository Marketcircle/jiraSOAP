# @todo complete this class
# Includes a mapping of project specific permission settings.
class JIRA::PermissionScheme < JIRA::Scheme
  add_attributes(
    ['permissionMappings', :permission_mappings, :children_as_objects, JIRA::PermissionMapping]
  )
end
