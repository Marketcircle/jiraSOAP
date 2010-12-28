module JIRA

# A structure that is a bit of a hack; it is just a key-value pair that
# is used by {RemoteAPI#update_issue}.
class FieldValue

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

# @todo see if @key is always nil from the server, maybe we can remove it
# @todo merge this class with JIRA::FieldValue
# Represents an instance of a custom field (with values). This object is used
# as a member of {JIRA::Issue} objects.
#
# The structure of this class resembles JIRA::FieldValue, it is different
# in that @values will always be stored as an Array of String objects for
# custom fields and a field value is more flexible. You can expect the classes
# to merge in the near future.
class CustomFieldValue < JIRA::DynamicEntity
  @attributes = {
    'customfieldId' => [:id=,     :to_s],
    'key'           => [:key=,    :to_s],
    'values'        => [:values=, :to_ss]
  }

  # @return [String]
  attr_accessor :key

  # @return [[String]]
  attr_accessor :values

  # Generate a SOAP message fragment for the object.
  # @param [Handsoap::XmlMason::Node] msg SOAP message to add the object to
  # @param [String] label tag name used in wrapping tags
  # @return [Handsoap::XmlMason::Element]
  def soapify_for(msg, label = 'customFieldValues')
    msg.add label do |submsg|
      submsg.add 'customfieldId', @id
      submsg.add 'key', @key
      submsg.add_simple_array 'values', @values
    end
  end
end

end
