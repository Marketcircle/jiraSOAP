class JIRA::Permission < JIRA::Entity
  add_attributes(
    # the permission type
    ['name',       :name,       :to_s],
    # a unique id number
    ['permission', :permission, :to_i]
  )
end
