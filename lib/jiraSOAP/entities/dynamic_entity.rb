##
# @abstract Anything that can be configured has an id field.
class JIRA::DynamicEntity < JIRA::Entity

  ##
  # Usually a numerical value, but sometimes prefixed with a string
  #
  # @example
  #  '12450'
  #  'customfield_10000'
  #
  # @return [String]
  add_attribute :id, 'id', :to_s

end
