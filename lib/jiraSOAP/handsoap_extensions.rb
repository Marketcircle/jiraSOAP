#Some simple extensions to Handsoap.
module Handsoap
#Some simple extensions to XmlMason. Currently, this only includes methods to
#make it easier to build SOAP messages that contain arrays.
module XmlMason
  #Represents a node in an XML document
  class Node
    #@todo Make this method recursive
    #@param [String] node_name
    #@param [Array] array
    #@param [Hash] options
    def add_simple_array(node_name, array = [], options = {})
      prefix, name = parse_ns(node_name)
      node = append_child Element.new(self, prefix, name, nil, options)
      array.each { |element| node.add node_name, element }
    end

    #@todo Make this method recursive
    #@param [String] node_name
    #@param [Array] array
    #@param [Hash] options
    def add_complex_array(node_name, array = [], options = {})
      prefix, name = parse_ns(node_name)
      node = append_child Element.new(self, prefix, name, nil, options)
      array.each { |element| element.soapify_for node, name }
    end
  end
end
end
