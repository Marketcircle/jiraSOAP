##
# Methods declared here do not directly map to methods defined in JIRA's
# SOAP API javadoc. They are generally close to something from the javadoc
# but with some extra conveniences.
module JIRA::RemoteAPIAdditions

  ##
  # Returns the first field that exactly matches the given
  # name, otherwise returns nil.
  #
  # @param [String] name
  # @return [JIRA::Field,nil]
  def custom_field_with_name name
    get_custom_fields.find { |cf| cf.name == name }
  end

end
