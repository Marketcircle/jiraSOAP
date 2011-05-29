##
# Though this class contains a name, it is not the same name that
# you get from a {JIRA::NamedEntity}.
class JIRA::UserGroup < JIRA::Entity
  add_attributes(
    ['name',  :name,  :content],
    ['users', :users, :children_as_objects, JIRA::User]
  )

  # I suspect that I will have to delete users from SOAPifying
end
