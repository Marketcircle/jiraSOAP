# A permission id and the username that it is tied to.
class JIRA::Permission < JIRA::Entity
  add_attributes(
    # The permission type
    ['name',       :name,       :to_s],
    # A unique id number
    ['permission', :permission, :to_i]
  )
end
