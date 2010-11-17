module JIRA

# Represents a filter, but does not seem to include the filters JQL query.
# @todo find out what @project is supposed to be for
class Filter < JIRA::DescribedEntity

  # @return [String]
  attr_accessor :author

  # @return [String]
  attr_accessor :project

  # @return [nil]
  attr_accessor :xml

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
    @author, @project, @xml =
      frag.nodes( ['author',  :to_s],
                  ['project', :to_s],
                  ['xml',     :to_s] )
  end
end

end
