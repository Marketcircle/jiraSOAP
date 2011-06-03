##
# @abstract A named entity that also has a short description
class JIRA::DescribedEntity < JIRA::NamedEntity

  # @return [String] A short blurb.
  add_attribute :description, 'description', :content

end
