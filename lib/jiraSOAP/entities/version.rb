##
# @todo find out why we don't get a description for this object
#
# Represents a version for a project. The description field is never
# included when you retrieve versions from the server.
class JIRA::Version < JIRA::NamedEntity
  add_attributes(
    ['sequence',    :sequence,     :to_i],
    ['released',    :released,     :to_boolean],
    ['archived',    :archived,     :to_boolean],
    ['releaseDate', :release_date, :to_iso_date]
  )

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
