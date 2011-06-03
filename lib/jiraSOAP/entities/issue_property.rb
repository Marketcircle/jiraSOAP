##
# @abstract A common base for most issue properties; core issue properties
#           also have an icon.
class JIRA::IssueProperty < JIRA::DescribedEntity

  ##
  # NSURL on MacRuby, URI::HTTP on CRuby
  #
  # @return [URI::HTTP,NSURL]
  add_attribute :icon, 'icon', :to_url

end
