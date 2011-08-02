##
# @abstract Most dynamic entities also have a name
class JIRA::NamedEntity < JIRA::DynamicEntity

  ##
  # A plain language name
  #
  # @return [String]
  add_attribute :name, 'name', :to_s

end
