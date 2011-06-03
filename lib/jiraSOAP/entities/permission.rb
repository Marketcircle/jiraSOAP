##
# A permission id and the username that it is tied to.
class JIRA::Permission < JIRA::Entity

  # @return [String] The permission type
  add_attribute :name, 'name', :content

  # @return [Number] A unique id number
  add_attribute :permission, 'permission', :to_i

end
