# @abstract The base class for all JIRA objects that can given by the server.
class JIRA::Entity

  class << self

    # @return [Hash{String=>Array<Symbol,Symbol,Class*>}] used for
    #  parsing XML
    attr_accessor :parse

    # @return [Hash{String=>Symbol}] used for building XML SOAP messages
    attr_accessor :build

    # @param [Array<String,Symbol,Class>] attributes
    # @return [Array<String,Symbol,Class>] returns what you gave it
    def add_attributes *attributes
      superclass = ancestors[1] # this is fragile to mixins
      @build = superclass.build.dup unless @build
      @parse = superclass.parse.dup unless @parse

      attributes.each { |attribute|
        jira_name, local_name = attribute[0..1]

        attr_accessor local_name

        @build[jira_name] = local_name

        @parse[jira_name] = [:"#{local_name}=", *attribute[2,2]]
        alias_method :"#{local_name}?", local_name if attribute[2] == :to_boolean
        #" ruby-mode parse fail
      }
    end

  end

  # they need to be initialized
  @build = {}
  @parse = {}

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Entity]
  def self.new_with_xml frag
    entity = allocate
    entity.initialize_with_xml frag
    entity
  end

  # @todo put debug message through the logger
  # @param [Nokogiri::XML::Element] element
  def initialize_with_xml frag
    attributes = self.class.parse
    frag.children.each { |node|
      action = attributes[node.name]
      self.send action[0], (node.send *action[1..-1]) if action
      #puts "Action is #{action.inspect} for #{node.node_name}"
    }
  end

  # Generate a SOAP message fragment for the object.
  # @param [Handsoap::XmlMason::Node] msg
  def to_soap msg
    self.class.build.each_pair { |node_name, value|
      builder = case value
                when Array then :add_simple_array
                else :add
                end
      msg.send builder, node_name, send(value)
    }
  end

end
