# @todo make sure the xml names are correct (check the XML dump)
class JIRA::PermissionMapping < JIRA::Entity
  add_attributes(
    ['permission', :permission, :to_object,  JIRA::Permission],
    ['entities',   :users,      :to_objects, JIRA::UserName]
  )
end
