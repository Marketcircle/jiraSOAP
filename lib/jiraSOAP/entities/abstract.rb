module JIRA

# @abstract The base class for all JIRA objects that can given by the server.
# @todo remove the need for attr_accessor by having add_attributes make the
#  call for me, but I will need to make a YARD plugin to fix the gap in the
#  documentation when that happens
class Entity

  class << self
    # @return [Hash{String => Array}] used by the metaclass
    attr_accessor :attributes

    # @param [Hash] attributes
    # @return [Hash]
    def add_attributes attributes
      @attributes = ancestors[1].attributes.dup
      @attributes.update attributes
    end
  end

  @attributes = {} # needs to be initialized

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Entity]
  def self.new_with_xml frag
    entity = allocate
    entity.initialize_with_xml frag
    entity
  end

  # @todo put debug message through the logger
  # @todo make this faster by cutting out NokogiriDriver,
  #  but I will need to add an accessor for @element of the
  #  driver object and then need to inject the marshaling
  #  methods into Nokogiri classes
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml frag
    attributes = self.class.attributes
    frag.children.each { |node|
      action = attributes[node.node_name]
      self.send action[0], (node.send *action[1..-1]) if action
      #puts "Action is #{action.inspect} for #{node.node_name}"
    }
  end
end

end
