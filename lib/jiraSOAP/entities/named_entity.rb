# @abstract Most dynamic entities also have a name
class JIRA::NamedEntity < JIRA::DynamicEntity
  add_attributes({ 'name' => [:name=, :to_s] })

  # @return [String] a plain language name
  attr_accessor :name
end
