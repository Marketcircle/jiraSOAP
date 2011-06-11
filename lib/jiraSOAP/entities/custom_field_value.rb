##
# @note There are no API methods that directly create objects of this class,
#       they are only created as an attribute of {JIRA::Issue} objects.
# @todo See if @key is always nil from the server, maybe we can remove it
#
# Represents an instance of a custom field (with values).
class JIRA::CustomFieldValue < JIRA::DynamicEntity

  # @return [String]
  add_attributes :id, 'customfieldId', :content

  # @return [String]
  add_attribute :key, 'key', :content

  # @return [Array<String>]
  add_attribute :values, 'values', :contents_of_children

  ##
  # Generate a SOAP message fragment for the object.
  #
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
