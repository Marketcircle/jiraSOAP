# This is just a @name, JIRA::User should inherit from this class
class JIRA::UserName < JIRA::Entity
  add_attributes(['name', :username, :content])
end
