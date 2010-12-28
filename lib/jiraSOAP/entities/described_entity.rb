# @abstract Some named entities have a short description
class JIRA::DescribedEntity < JIRA::NamedEntity
  add_attributes({ 'description' => [:description=, :to_s] })

  # @return [String] usually a short blurb
  attr_accessor :description
end
