##
# This class is a bit of a hack; it is really just a key-value pair and only
# used with {RemoteAPI#update_issue}.
class JIRA::FieldValue

  # @return [String] the name for regular fields, and the id for custom fields
  attr_accessor :field_name

  # @return [Array<#to_s>] an array for the values, usually a single
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
  # @todo Soapify properly for custom objects (JIRA module).
  #
  # @param [Handsoap::XmlMason::Node] message the node to add the object to
  # @param [String] label name for the tags that wrap the message
  # @return [Handsoap::XmlMason::Element]
  def to_soap msg
    msg.add 'fieldValue' do |submsg|
      submsg.add 'id', @field_name
      submsg.add_simple_array 'values', @values if @values
    end
  end
end
