##
# @todo Make sure the xml names are correct (check the XML dump)
class JIRA::PermissionMapping < JIRA::Entity
  add_attributes(
    ['permission', :permission, :children_as_object,  JIRA::Permission],
    ['entities',   :users,      :children_as_objects, JIRA::UserName]
  )
end
