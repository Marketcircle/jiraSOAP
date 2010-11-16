module JIRA

# @abstract
# The base class for all JIRA objects that can be created by the server.
class Entity
  def self.new_with_xml_fragment(frag)
    entity = allocate
    entity.initialize_with_xml_fragment frag
    entity
  end

  def initialize_with_xml_fragment(frag)
    raise NotImplementedError.new, 'Subclasses should override and implement'
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
  # @return [String]
  def type
    self.class.to_s
  end
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
