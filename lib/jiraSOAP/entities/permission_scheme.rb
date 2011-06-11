##
# @todo Complete this class
#
# Includes a mapping of project specific permission settings.
class JIRA::PermissionScheme < JIRA::Scheme

  # @return [Array<JIRA::PermissionMapping>]
  add_attribute :permission_mappings, 'permissionMappings', [:children_as_objects, JIRA::PermissionMapping]

end
