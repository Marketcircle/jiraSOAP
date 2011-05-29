##
# @abstract A common base for most issue properties; core issue properties
#           also have an icon.
class JIRA::IssueProperty < JIRA::DescribedEntity
  add_attributes(
    # NSURL on MacRuby and a URI::HTTP object on CRuby
    ['icon', :icon, :to_url]
  )
end
