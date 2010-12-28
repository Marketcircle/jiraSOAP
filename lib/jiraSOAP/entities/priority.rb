# Contains all the metadata for a priority level.
class JIRA::Priority < JIRA::IssueProperty
  add_attributes({ 'color' => [:color=, :to_hex_string] })

  # @return [Array(String,String,String)] the RGB components as a triple
  attr_accessor :color
  alias_method :colour, :color
  alias_method :colour=, :color=
end
