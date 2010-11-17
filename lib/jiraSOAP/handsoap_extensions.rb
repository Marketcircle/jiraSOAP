# Some simple extensions to Handsoap.
module Handsoap
# Some simple extensions to XmlMason. Currently, this only includes methods to
# make it easier to build SOAP messages that contain arrays.
module XmlMason
  # Represents a node in an XML document used for SOAP message creation.
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

# Some simple extensions to make initialization of JIRA objects cleaner.
module XmlQueryFront
  # Represents a node in an XML document used when parsing SOAP responses.
  # This class is extended for use with jiraSOAP.
  class NokogiriDriver

    # @param [Array] *attributes pairs or triplets, the first element is the
    #  attribute you want, the second element is the method to send to the
    #  result, and the third element is the argument to that method (if needed)
    # @return [[Objects]]
    def nodes(*attributes)
      attributes.map { |attr|
        self.xpath(attr.shift).send *attr
      }
    end

    # @return [Time]
    def to_string_date
      temp = self.to_s
      return unless temp
      Time.new temp
    end

    # @return [URL]
    def to_url
      temp = self.to_s
      return if temp.empty?
      URL.new temp
    end

    # @return [[String]]
    def to_ss
      self.map { |val| val.to_s }
    end
  end

  # Simple additions to help expedite parsing XML.
  class NodeSelection
    # @return [URL]
    def to_url
      self.first.to_url if self.any?
    end

    # @return [Time]
    def to_string_date
      self.first.to_string_date
    end
    # @param [Class] klass the object you want an array of
    # @return [Array] an array of klass objects
    def to_objects(klass)
      self.map { |frag| klass.new_with_xml_fragment frag }
    end

    # @param [Class] klass the object you want to make
    # @return [Object] an instance of klass
    def to_object(klass)
      klass.new_with_xml_fragment self.first if self.any?
    end
  end
end

end
