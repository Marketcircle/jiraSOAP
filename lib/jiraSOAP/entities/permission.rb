##
# A permission id and the username that it is tied to.
class JIRA::Permission < JIRA::Entity

  ##
  # The permission type
  #
  # @return [String]
  add_attribute :name, 'name', :to_s

  ##
  # A unique id number
  #
  # @return [Number]
  add_attribute :permission, 'permission', :to_i

end
