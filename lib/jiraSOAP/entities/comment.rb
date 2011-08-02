##
# Contains a comment's body and metadata.
class JIRA::Comment < JIRA::DynamicEntity

  ##
  # A username
  #
  # @return [String]
  add_attribute :author, 'author', :to_s

  # @return [String]
  add_attribute :body, 'body', :to_s

  # @return [String]
  add_attribute :group_level, 'groupLevel', :to_s

  # @return [String]
  add_attribute :role_level, 'roleLevel', :to_s

  ##
  # A username
  #
  # @return [String]
  add_attribute :update_author, 'updateAuthor', :to_s

  # @return [Time]
  add_attribute :create_time, 'created', :to_iso_date

  # @return [Time]
  add_attribute :last_updated_time, 'updated', :to_iso_date

  ##
  # Add a created comment to an issue
  def add_to issue_key
    raise NotImplementedError, 'Please implement me. :('
  end

  ##
  # @todo make this method shorter
  #
  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for(msg)
    msg.add 'id', @id
    msg.add 'author', @author
    msg.add 'body', @body
    msg.add 'groupLevel', @group_level
    msg.add 'roleLevel', @role_level
    msg.add 'updateAuthor', @update_author
  end

end
