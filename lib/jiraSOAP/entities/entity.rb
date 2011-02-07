# @abstract The base class for all JIRA objects that can given by the server.
class JIRA::Entity

  class << self

    # @return [Hash{String=>Array<Symbol,Symbol,Class*>}] used by the
    #  metaclass for parsing XML
    attr_accessor :parse

    # @param [Array<String,Symbol,Class>] attributes
    # @return [nil]
    def add_attributes *attributes
      superclass = ancestors[1]
      @parse = superclass.parse.dup

      attributes.each { |attribute|
        attr_accessor attribute[1]
        @parse[attribute[0]] = [:"#{attribute[1]}=", *attribute[2,2]]
        alias_method :"#{attribute[1]}?", attribute[1] if attribute[2] == :to_boolean
        #" ruby-mode parse fail
      }
    end

  end

  @parse = {} # needs to be initialized

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
    attributes = self.class.parse
    frag.children.each { |node|
      action = attributes[node.node_name]
      self.send action[0], (node.send *action[1..-1]) if action
      #puts "Action is #{action.inspect} for #{node.node_name}"
    }
  end

end
