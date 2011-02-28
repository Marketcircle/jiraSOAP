##
# @note You can only read filters from the server, there are no API methods
#  for creating, updating, or deleting filters from the server.
#
# Represents a filter, but does not seem to include the filters JQL query.
class JIRA::Filter < JIRA::DescribedEntity
  add_attributes(
    ['author',  :author,       :content],
    ['project', :project_name, :content],
    # @todo Find out what this is for, perhaps it is the XML form of
    #  equivalent JQL query?
    ['xml',     :xml,          :content]
  )
end
