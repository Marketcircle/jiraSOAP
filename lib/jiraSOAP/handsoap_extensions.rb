# Some simple extensions to Handsoap.
module Handsoap

# @todo check if these methods already exist in Handsoap::Service
# Some extensions to the XML builder to make message building less ugly.
module XmlMason

  # A node in a Nokogiri XML document.
  class Node

    # @todo Make this method recursive
    # @param [String] node_name
    # @param [Array] array
    # @param [Hash] options
    def add_simple_array(node_name, array = [], options = {})
      prefix, name = parse_ns(node_name)
      node = append_child Element.new(self, prefix, name, nil, options)
      array.each { |element| node.add node_name, element }
    end

    # @todo Make this method recursive
    # @param [String] node_name
    # @param [Array] array
    # @param [Hash] options
    def add_complex_array(node_name, array = [], options = {})
      prefix, name = parse_ns(node_name)
      node = append_child Element.new(self, prefix, name, nil, options)
      array.each { |element| element.soapify_for node, name }
    end

  end

end


# These are simple extensions to the existing class provided by Handsoap.
module XmlQueryFront

  # @todo move these extensions straight to the nokogiri layer
  # Simple extensions on the existing Handsoap class to make parsing easier.
  class NokogiriDriver

    # Parses non-strict date strings into Time objects.
    # @return [Time]
    def to_date_string
      temp = self.to_s
      return unless temp
      Time.new temp
    end

    # This is a bit naive, but should be sufficient for its purpose.
    # @return [String]
    def to_hex_string
      temp = self.to_s
      return unless temp
      temp.match(/#(..)(..)(..)/).captures
    end

    # @return [URL]
    def to_url
      temp = self.to_s
      return unless temp
      URL.new temp
    end

    # Returns the node's children to an array of strings.
    # @return [[String]]
    def to_ss
      children.map { |val| val.to_s }
    end

    # @param [Class] klass the object you want to make
    # @return [Object] an instance of klass
    def to_object klass
      klass.new_with_xml self
    end

    # @param [Class] klass the object you want an array of
    # @return [Array] an array of klass objects
    def to_objects klass
      children.map { |node| klass.new_with_xml node }
    end
  end
end

end
