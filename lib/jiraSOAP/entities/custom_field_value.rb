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

  # @param [Handsoap::XmlMason::Node] msg SOAP message to add the object to
  # @param [String] label tag name used in wrapping tags
  # @return [Handsoap::XmlMason::Element]
  def to_soap msg, label = 'customFieldValues'
    msg.add label do |submsg| super submsg end
  end

end
