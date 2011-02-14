# @abstract Some named entities have a short description
class JIRA::DescribedEntity < JIRA::NamedEntity
  add_attributes(
    # A short blurb.
    ['description', :description, :content]
  )
end
