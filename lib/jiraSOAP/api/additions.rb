module JIRA

# Methods declared here do not directly map to methods defined in JIRA's
# SOAP API javadoc. They are generally close to something from the javadoc
# but with some extra conveniences.
module RemoteAPIAdditions

  # Returns the first field that exactly matches the given
  # name, otherwise returns nil.
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

end
