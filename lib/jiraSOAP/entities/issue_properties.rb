module JIRA

  # @abstract A common base for most issue properties; core issue properties
  #  have an icon to go with them to help identify properties of issues more
  #  quickly.
  class IssueProperty < JIRA::DescribedEntity
    add_attributes({ 'icon' => [:icon=, :to_url] })

    # @return [URL] NSURL on MacRuby and a URI::HTTP object on CRuby
    attr_accessor :icon
  end


  # Contains all the metadata for a resolution.
  class Resolution < JIRA::IssueProperty
    add_attributes({})
  end


  # Contains all the metadata for an issue's status.
  class Status < JIRA::IssueProperty
    add_attributes({})
  end


  # Contains all the metadata for a priority level.
  class Priority < JIRA::IssueProperty
    add_attributes({ 'color' => [:color=, :to_hex_string] })

    # @return [Array(String,String,String)] the RGB components as a triple
    attr_accessor :color
    alias_method :colour, :color
    alias_method :colour=, :color=
  end


  # Contains all the metadata for an issue type.
  class IssueType < JIRA::IssueProperty
    add_attributes({ 'subTask' => [:subtask=, :to_boolean] })

    # @return [boolean]  true if the issue type is also a subtask
    attr_accessor :subtask
    alias_method :subtask?, :subtask
  end

end
