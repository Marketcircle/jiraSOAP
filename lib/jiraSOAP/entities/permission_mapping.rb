##
# @todo Make sure the xml names are correct (check the XML dump)
class JIRA::PermissionMapping < JIRA::Entity

  # @return [Array<JIRA::Permission>]
  add_attribute :permission, 'permission', [:children_as_object,  JIRA::Permission]

  # @return [Array<JIRA::UserName>]
  add_attribute :users, 'entities', [:children_as_objects, JIRA::UserName]

end
