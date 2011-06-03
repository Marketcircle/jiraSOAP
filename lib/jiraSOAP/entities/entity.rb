##
# @abstract The base class for all JIRA objects that can given by the server.
class JIRA::Entity

  class << self

    # @return [Hash{String=>Array(Symbol,Symbol,Class*)}] used for parsing XML
    attr_accessor :parse

    # @return [Hash{String=>Symbol}] used for building XML SOAP messages
    attr_accessor :build

    ##
    # Define the callback to automatically initialize the build and parse
    # tables when any subclass is defined.
    def inherited subclass
      subclass.build = @build.dup
      subclass.parse = @parse.dup
    end

    ##
    # @todo Add a way to signify if an attribute should not be used in
    #       message building, as some attributes should never be included
    #       in a SOAP message.
    #
    # Define a single instance attribute on the class including the
    # specification on how to parse the XML output and how to build
    # SOAP messages.
    #
    # Predicate methods will automatically be created if the transformer
    # method is `:to_boolean`.
    #
    # @param [Symbol] name name of the attribute to create
    # @param [String] jira_name name of the XML tag to look for when
    #   parsing responses from the server
    # @param [Symbol,Array(Symbol,Class)] transformer either the method
    #   name to transform some XML contents, or the method name and the
    #   class to build from the attribute
    # @return [nil]
    def add_attribute name, jira_name, transformer
      attr_accessor name
      alias_method "#{name}?", name if transformer == :to_boolean

      @build[jira_name] = name
      @parse[jira_name] = [:"#{name}=", *transformer]
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

  # @param [Nokogiri::XML::Element] element
  def initialize_with_xml frag
    attributes = self.class.parse
    frag.children.each { |node|
      action = attributes[node.name]
      self.send action[0], (node.send *action[1..-1]) if action
      #puts "Action is #{action.inspect} for #{node.node_name}"
    }
  end

  ##
  # Generate a SOAP message fragment for the object.
  #
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
