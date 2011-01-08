# @todo see if @key is always nil from the server, maybe we can remove it
# Represents an instance of a custom field (with values). This object is used
# as a member of {JIRA::Issue} objects.
#
# The structure of this class resembles JIRA::FieldValue, it is different
# in that @values will always be stored as an Array of String objects for
# custom fields and a field value is more flexible. You can expect the classes
# to merge in the near future.
class JIRA::CustomFieldValue < JIRA::DynamicEntity
  add_attributes(
    ['customfieldId', :id,     :to_s],
    ['key',           :key,    :to_s],
    ['values',        :values, :to_s]
  )

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
