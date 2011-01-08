# This is just a @name, JIRA::User should inherit from this class
class JIRA::RemoteEntity < JIRA::Entity
  add_attributes({ 'name' => [:name=, :to_s] })

  # @return [String]
  attr_accessor :name
end
