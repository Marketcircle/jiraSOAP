# @abstract A common base for most issue properties; core issue properties
#  have an icon to go with them to help identify properties of issues more
#  quickly.
class JIRA::IssueProperty < JIRA::DescribedEntity
  add_attributes(
    # NSURL on MacRuby and a URI::HTTP object on CRuby
    ['icon', :icon, :to_url]
  )
end
