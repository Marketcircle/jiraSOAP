module JIRA

# @todo complete this class
# Includes a mapping of project specific permission settings.
class PermissionScheme < JIRA::Scheme

  # @return [nil]
  attr_accessor :permission_mappings

  # @todo actually parse the permission mapping
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
  end
end

# Basic metadata about a project's notification scheme.
class NotificationScheme < JIRA::Scheme
end

# Basic metadata about a project's issue security scheme.
class IssueSecurityScheme < JIRA::Scheme
end

end
