class JIRA::PermissionMapping < JIRA::Entity
  @attributes = {
    'permission' => [:permission=, :to_object,  JIRA::Permission],
    'permission' => [:permission=, :to_objects, JIRA::Permission]
  }

  # @return [JIRA::Permission]
  attr_accessor :permission

  # @return [[JIRA::RemoteEntity]]
  attr_accessor :remote_entities
end
