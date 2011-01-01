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
end
