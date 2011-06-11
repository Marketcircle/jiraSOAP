##
# Contains all the metadata for a priority level.
class JIRA::Priority < JIRA::IssueProperty

  ##
  # The RGB components as a triple
  #
  # @return [Array(String,String,String)]
  add_attribute :color, 'color', :to_colour_triple
  alias_method :colour, :color
  alias_method :colour=, :color=

end
