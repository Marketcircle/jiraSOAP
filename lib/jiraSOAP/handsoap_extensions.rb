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


# Exposing an attribute in the underlying NokogiriDriver class.
module XmlQueryFront

  # Monkey patch to expose the underlying Nokogiri object
  class NokogiriDriver
    # @return [Nokogiri::XML::Element]
    attr_reader :element
  end

end
end
