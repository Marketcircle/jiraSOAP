##
# Monkey patches to allow the SOAP building method to not need
# a special case for dealing with arrays.
class Array

  # @param [Handsoap::XmlMason::Node] msg message the node to add the object to
  def soapify_for msg
    each { |item| item.soapify_for msg }
  end

end
