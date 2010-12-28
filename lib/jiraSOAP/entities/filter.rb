module JIRA

# Represents a filter, but does not seem to include the filters JQL query.
# @todo find out what @project is supposed to be for
class Filter < JIRA::DescribedEntity
  add_attributes({
    'author'  => [:author=,  :to_s],
    'project' => [:project=, :to_s],
    'xml'     => [:xml=,     :to_s]
  })

  # @return [String]
  attr_accessor :author

  # @return [String]
  attr_accessor :project

  # @return [nil]
  attr_accessor :xml
end

end
