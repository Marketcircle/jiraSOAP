module JIRA

# Contains all the metadata for a resolution.
class Resolution < JIRA::IssueProperty
end

# Contains all the metadata for an issue's status.
class Status < JIRA::IssueProperty
end

# Contains all the metadata for a priority level.
# @todo change @color to be some kind of hex Fixnum object
class Priority < JIRA::IssueProperty

  # @return [String] is a hex value
  attr_accessor :color

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
    @color = (frag/'color').to_s
  end
end

# Contains all the metadata for an issue type.
class IssueType < JIRA::IssueProperty

  # @return [boolean]
  attr_accessor :subtask

  # @return [boolean] true if the issue type is a subtask, otherwise false
  def subtask?; @subtask; end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
    @subtask = (frag/'subTask').to_boolean
  end
end

end
