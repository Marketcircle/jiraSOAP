##
# @todo Find out why we don't get a description for this object
#
# Represents a version for a project. The description field is never
# included when you retrieve versions from the server.
class JIRA::Version < JIRA::NamedEntity

  # @return [Number]
  add_attribute :sequence, 'sequence', :to_i

  # @return [Boolean]
  add_attribute :released, 'released', :to_boolean

  # @return [Boolean]
  add_attribute :archived, 'archived', :to_boolean

  # @return [Time]
  add_attribute :release_date, 'releaseDate', :to_iso_date

  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for(msg)
    msg.add 'name', @name
    msg.add 'archived', @archived if @archived
    msg.add 'sequence', @sequence if @sequence
    msg.add 'releaseDate', @release_date.xmlschema if @release_date
    msg.add 'released', @released if @released
  end

end
