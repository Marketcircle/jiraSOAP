# Represents a filter, but does not seem to include the filters JQL query.
class JIRA::Filter < JIRA::DescribedEntity
  add_attributes(
    ['author',  :author,       :to_s],
    ['project', :project_name, :to_s],
    ['xml',     :xml,          :to_s]
  )
end
