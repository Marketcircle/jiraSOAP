# A structure that is a bit of a hack; it is just a key-value pair that
# is used by {RemoteAPI#update_issue}.
class JIRA::FieldValue

  # @return [String] the name for regular fields, and the id for custom fields
  attr_accessor :field_name

  # @return [Array(#to_s)] an array for the values, usually a single
  attr_accessor :values

  # @param [String] field_name
  # @param [Array] values
  def initialize(field_name = nil, values = nil)
    @field_name = field_name
    @values     = values
  end

  # @todo soapify properly for custom objects (JIRA module).
  # @param [Handsoap::XmlMason::Node] message the node to add the object to
  # @param [String] label name for the tags that wrap the message
  # @return [Handsoap::XmlMason::Element]
  def soapify_for(message, label = 'fieldValue')
    message.add label do |message|
      message.add 'id', @field_name
      message.add_simple_array 'values', @values unless @values.nil?
    end
  end
end
