##
# @note You can only read filters from the server, there are no API methods
#       for creating, updating, or deleting filters from the server.
#
# Represents a filter, but does not seem to include the filters JQL query.
class JIRA::Filter < JIRA::DescribedEntity

  # @return [String]
  add_attribute :author, 'author', :content

  # @return [String]
  add_attribute :project_name, 'project', :content

  ##
  # @todo Find out what this is for, perhaps it is the XML form of
  #       equivalent JQL query?
  #
  # @return [String]
  add_attribute :xml, 'xml', :content

end
