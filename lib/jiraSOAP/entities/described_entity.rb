# @abstract Some named entities have a short description
class JIRA::DescribedEntity < JIRA::NamedEntity
  add_attributes(
    # usually a short blurb
    ['description', :description, :to_s]
  )
end
