module JIRA

  # @abstract
  # Schemes used by the server.
  class Scheme < JIRA::DescribedEntity
    add_attributes({})

    # Child classes need to be careful when encoding the scheme type to XML.
    # @return [Class]
    alias_method :type, :class
  end


  # Basic metadata about a project's notification scheme.
  class NotificationScheme < JIRA::Scheme
    add_attributes({})
  end


  # Basic metadata about a project's issue security scheme.
  class IssueSecurityScheme < JIRA::Scheme
    add_attributes({})
  end


  # @todo complete this class
  # Includes a mapping of project specific permission settings.
  class PermissionScheme < JIRA::Scheme
    add_attributes({})

    # @return [nil]
    attr_accessor :permission_mappings
  end

end
