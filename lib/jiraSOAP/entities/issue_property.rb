##
# @abstract A common base for most issue properties; core issue properties
#           also have an icon.
class JIRA::IssueProperty < JIRA::DescribedEntity

  # @return [URI::HTTP,NSURL] NSURL on MacRuby, URI::HTTP on CRuby
  add_attribute :icon, 'icon', :to_url

end
