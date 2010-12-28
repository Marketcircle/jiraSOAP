# @abstract A common base for most issue properties; core issue properties
#  have an icon to go with them to help identify properties of issues more
#  quickly.
class JIRA::IssueProperty < JIRA::DescribedEntity
  add_attributes({ 'icon' => [:icon=, :to_url] })

  # @return [URL] NSURL on MacRuby and a URI::HTTP object on CRuby
  attr_accessor :icon
end
