module JIRA

# @abstract
# The base class for all JIRA objects that can be created by the server.
class Entity

  class << self
    attr_accessor :attributes
  end

  @attributes = {}

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Entity]
  def self.new_with_xml_fragment frag
    entity = allocate
    entity.initialize_with_xml_fragment frag
    entity
  end

  # @todo put debug message through the logger
  # @todo make this faster by cutting out NokogiriDriver,
  #  but I will need to add an accessor for @element of the
  #  driver object and then need to inject the marshaling
  #  methods into Nokogiri classes
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    attributes = self.class.attributes
    frag.children.each { |node|
      action = attributes[node.node_name]
      # puts "Action is #{action.inspect} for #{node.node_name}"
      self.send action[0], (node.send *action[1..-1])
    }
  end
end

# @abstract
# Most JIRA objects will have an id attribute as a unique identifier in
# their area.
class DynamicEntity < JIRA::Entity

  # @return [String] usually holds a numerical value but for consistency with
  #  with id's from custom fields this attribute is always a String
  attr_accessor :id

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    @id = (frag/'id').to_s
  end
end

# @abstract
# Many JIRA objects include a name.
class NamedEntity < JIRA::DynamicEntity

  # @return [String] a plain language name
  attr_accessor :name

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
    @name = (frag/'name').to_s
  end
end

# @abstract
# Several JIRA objects include a short description.
class DescribedEntity < JIRA::NamedEntity

  # @return [String] usually a short blurb
  attr_accessor :description

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
    @description = (frag/'description').to_s
  end
end

# @abstract
# Represents a scheme used by the server. Not very useful for the sake of the
# API; a more useful case might be if you wanted to emulate the server's
# behaviour.
class Scheme < JIRA::DescribedEntity
  # Schemes that inherit this class will have to be careful when they try
  # to encode the scheme type in an xml message.
  # @return [Class]
  alias_method :type, :class
end

# @abstract
# A common base for most issue properties. Core issue properties have
# an icon to go with them to help identify properties of issues more
# quickly.
class IssueProperty < JIRA::DescribedEntity

  # @return [URL] A NSURL on MacRuby and a URI::HTTP object in CRuby
  attr_accessor :icon

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
    @icon = (frag/'icon').to_url
  end
end

end
