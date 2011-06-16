##
# @abstract The base class for all JIRA objects that can given by the server.
class JIRA::Entity

  class << self

    # @return [Hash{String=>Array(Symbol,Symbol,Class*)}] used for parsing XML
    attr_accessor :parse

    # @return [Hash{String=>Array(Symbol,Symbol,Class*)}] used for parsing XML
    attr_accessor :build

    ##
    # Define the callback to automatically initialize the build and parse
    # tables when any subclass is defined.
    def inherited subclass
      subclass.parse = @parse.dup
      subclass.build = @build.dup
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
      @parse[jira_name] = [:"#{name}=", *transformer]
      @build[jira_name] = name

      attr_accessor name
      alias_method "#{name}?", name if transformer == :to_boolean
    end

    ##
    # Alias an attribute's reader and writer methods
    #
    # @param [Symbol] new_name
    # @param [Symbol] old_name
    # @return [nil]
    def alias_attribute new_name, old_name
      alias_method new_name, old_name
      alias_method "#{new_name}=", "#{old_name}="
      if public_instance_methods.include?("#{old_name}?".to_sym)
        alias_method "#{new_name}?", old_name
      end
    end

  end

  # needs to be initialized
  @parse = {}
  @build = {}

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

end
