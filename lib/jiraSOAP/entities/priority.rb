##
# Contains all the metadata for a priority level.
class JIRA::Priority < JIRA::IssueProperty

  # @return [Array(String,String,String)] the RGB components as a triple
  add_attribute :color, 'color', :to_colour_triple
  alias_method :colour, :color
  alias_method :colour=, :color=

end
