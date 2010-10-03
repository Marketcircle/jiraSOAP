#PONDER: send upstream for consideration
module Handsoap
module XmlMason
  class Node
    #TODO: make recursive
    def add_simple_array(node_name, array = [], options = {})
      prefix, name = parse_ns(node_name)
      node = append_child Element.new(self, prefix, name, nil, options)
      array.each { |element| node.add node_name, element }
    end

    def add_complex_array(node_name, array = [], options = {})
      prefix, name = parse_ns(node_name)
      node = append_child Element.new(self, prefix, name, nil, options)
      array.each { |element| element.soapify_for node, name }
    end
  end
end
end
