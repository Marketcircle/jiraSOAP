##
# This is just a @name, JIRA::User should inherit from this class
class JIRA::UserName < JIRA::Entity

  # @return [String]
  add_attribute :username, 'name', :content

end
