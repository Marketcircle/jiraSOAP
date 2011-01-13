module JIRA

# Methods declared here do not directly map to methods defined in JIRA's
# SOAP API javadoc. They are generally close to something from the javadoc
# but with some extra conveniences.
module RemoteAPIAdditions

  # Returns nil if the field is not found.
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
