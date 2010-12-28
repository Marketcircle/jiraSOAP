# @todo find out why we don't get a description for this object
# Represents a version for a project. The description field is never
# included when you retrieve versions from the server.
class JIRA::Version < JIRA::NamedEntity
  add_attributes({
    'sequence'    => [:sequence=,     :to_i],
    'released'    => [:released=,     :to_boolean],
    'archived'    => [:archived=,     :to_boolean],
    'releaseDate' => [:release_date=, :to_date]
  })

  # @return [Fixnum]
  attr_accessor :sequence

  # @return [boolean]
  attr_accessor :released
  alias_method :released?, :released

  # @return [boolean]
  attr_accessor :archived
  alias_method :archived?, :archived

  # @return [Time]
  attr_accessor :release_date

  # @todo make this method shorter
  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for(msg)
    msg.add 'name', @name
    msg.add 'archived', @archived unless @archived.nil?
    msg.add 'sequence', @sequence unless @sequence.nil?
    msg.add 'releaseDate', @release_date.xmlschema unless @release_date.nil?
    msg.add 'released', @released unless @released.nil?
  end
end
