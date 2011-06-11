##
# This class is a bit of a hack; it is really just a key-value pair and only
# used with {RemoteAPI#update_issue}.
class JIRA::FieldValue

  ##
  # The name for regular fields, and the id for custom fields
  #
  # @return [String]
  attr_accessor :field_name

  ##
  # An array for the values, usually only has one object
  #
  # @return [Array<#to_s>]
  attr_accessor :values

  # @param [String] field_name
  # @param [Array] values
  def initialize field_name = nil, values = nil
    @field_name = field_name
    if values
      @values = values.is_a?( ::Array ) ? values : [values]
    end
  end

  ##
  # @todo soapify properly for custom objects (JIRA module).
  #
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
