# Contains all the metadata for a priority level.
class JIRA::Priority < JIRA::IssueProperty
  add_attributes(
    # the RGB components as a triple
    ['color', :color, :to_colour_triple]
  )

  alias_method :colour, :color
  alias_method :colour=, :color=
end
