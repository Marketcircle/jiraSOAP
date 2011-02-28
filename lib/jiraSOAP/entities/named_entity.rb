##
# @abstract Most dynamic entities also have a name
class JIRA::NamedEntity < JIRA::DynamicEntity
  add_attributes(
    # A plain language name
    ['name', :name, :content]
  )
end
