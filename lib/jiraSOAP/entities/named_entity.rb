# @abstract Most dynamic entities also have a name
class JIRA::NamedEntity < JIRA::DynamicEntity
  add_attributes(
    # a plain language name
    ['name', :name, :to_s]
  )
end
