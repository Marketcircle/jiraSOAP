##
# @todo Push these upstream?
#
# Some simple extensions to Handsoap to make building SOAP messages easier.
class Handsoap::XmlMason::Node
  ##
  # @todo Make this method recursive
  #
  # @param [String] node_name
  # @param [Array] array
  # @param [Hash] options
  def add_simple_array node_name, array = [], options = {}
    prefix, name = parse_ns(node_name)
    node = append_child Handsoap::XmlMason::Element.new(self, prefix, name, nil, options)
    array.each { |element| node.add node_name, element }
  end

  ##
  # @todo Make this method recursive
  #
  # @param [String] node_name
  # @param [Array] array
  # @param [Hash] options
  def add_complex_array node_name, array = [], options = {}
    prefix, name = parse_ns(node_name)
    node = append_child Handsoap::XmlMason::Element.new(self, prefix, name, nil, options)
    array.each { |element| element.soapify_for node, name }
  end
end
