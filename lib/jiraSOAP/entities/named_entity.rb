##
# @abstract Most dynamic entities also have a name
class JIRA::NamedEntity < JIRA::DynamicEntity

  # @return [String] A plain language name
  add_attribute :name, 'name', :content

end
