##
# @abstract A named entity that also has a short description
class JIRA::DescribedEntity < JIRA::NamedEntity

  ##
  # A short blurb
  #
  # @return [String]
  add_attribute :description, 'description', :to_s

end
