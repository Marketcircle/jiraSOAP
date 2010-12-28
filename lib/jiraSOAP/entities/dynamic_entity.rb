# @abstract Anything that can be configured has an id field.
class JIRA::DynamicEntity < JIRA::Entity
  add_attributes({ 'id' => [:id=, :to_s] })

  # @return [String] usually a numerical value, but sometimes
  #  prefixed with a string (e.g. '12450' or 'customfield_10000')
  attr_accessor :id
end
