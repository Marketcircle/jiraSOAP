# @abstract Anything that can be configured has an id field.
class JIRA::DynamicEntity < JIRA::Entity
  add_attributes(
    # Usually a numerical value, but sometimes prefixed with a
    #  string (e.g. '12450' or 'customfield_10000')
    ['id', :id, :content]
  )
end
