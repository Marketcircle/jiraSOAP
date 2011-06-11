##
# Only a name, description, and id.
class JIRA::ProjectRole < JIRA::DescribedEntity

  # @param [Handsoap::XmlMason::Node] msg the node where to add self
  def soapify_for msg
    msg.add 'id', @id
    msg.add 'name', @name
    msg.add 'description', @description
  end

end
