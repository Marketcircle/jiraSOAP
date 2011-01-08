# @abstract Anything that can be configured has an id field.
class JIRA::DynamicEntity < JIRA::Entity
  add_attributes(
    # usually a numerical value, but sometimes prefixed with a
    #  string (e.g. '12450' or 'customfield_10000')
    ['id', :id, :to_s]
  )
end
