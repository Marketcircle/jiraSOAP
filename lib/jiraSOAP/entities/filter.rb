# Represents a filter, but does not seem to include the filters JQL query.
class JIRA::Filter < JIRA::DescribedEntity
  add_attributes(
    ['author',  :author,       :content],
    ['project', :project_name, :content],
    ['xml',     :xml,          :content]
  )
end
