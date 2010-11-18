module JIRA

# Represents a version for a project. The description field is never
# included when you retrieve versions from the server.
# @todo find out why we don't get a description for this object
class Version < JIRA::NamedEntity

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

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
    @sequence, @released, @archived, @release_date =
      frag.nodes( ['sequence',    :to_i],
                  ['released',    :to_boolean],
                  ['archived',    :to_boolean],
                  ['releaseDate', :to_date] )
  end

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

end
