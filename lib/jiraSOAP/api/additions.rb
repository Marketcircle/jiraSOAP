##
# Methods declared here do not directly map to methods defined in JIRA's
# SOAP API javadoc. They are extra methods that have been found to be
# generally helpful.
module JIRA::RemoteAPIAdditions
  ##
  # Returns the first field that exactly matches the given name,
  # otherwise returns nil.
  #
  # @param [String] name
  # @return [JIRA::Field,nil]
  def get_custom_field_with_name name
    get_custom_fields.each { |cf|
      return cf if cf.name == name
    }
    nil
  end

  # @todo a method for getting attachments
end
