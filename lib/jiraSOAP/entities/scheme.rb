# @abstract
# Schemes used by the server.
class JIRA::Scheme < JIRA::DescribedEntity
  # Child classes need to be careful when encoding the scheme type to XML.
  # @return [Class]
  alias_method :type, :class
end
