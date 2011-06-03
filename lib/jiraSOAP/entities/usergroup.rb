##
# Though this class contains a name, it is not the same name that
# you get from a {JIRA::NamedEntity}.
class JIRA::UserGroup < JIRA::Entity

  # @return [String]
  add_attribute :name, 'name', :content

  ##
  # @todo I suspect that I will have to delete users from SOAPifying
  #
  # @return [Array<JIRA::User>]
  add_attribute :users, 'users', [:children_as_objects, JIRA::User]

end
