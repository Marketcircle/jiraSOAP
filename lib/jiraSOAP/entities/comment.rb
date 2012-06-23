##
# Contains a comment's body and metadata.
class JIRA::Comment < JIRA::DynamicEntity

  ##
  # A username
  #
  # @return [String]
  add_attribute :author, 'author', :content

  # @return [String]
  add_attribute :body, 'body', :content

  # @return [String]
  add_attribute :group_level, 'groupLevel', :content

  # @return [String]
  add_attribute :role_level, 'roleLevel', :content

  ##
  # A username
  #
  # @return [String]
  add_attribute :update_author, 'updateAuthor', :content

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
  def soapify_for msg
    msg.add 'id', @id
    msg.add 'author', @author
    msg.add 'body', @body
    msg.add 'groupLevel', @group_level if @group_level
    msg.add 'roleLevel', @role_level if @role_level
    msg.add 'updateAuthor', @update_author if @update_author
  end

end
