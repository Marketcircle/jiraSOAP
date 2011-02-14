# Contains a comment's body and metadata.
class JIRA::Comment < JIRA::DynamicEntity
  add_attributes(
    # A username
    ['author',       :author,            :content],
    ['body',         :body,              :content],
    ['groupLevel',   :group_level,       :content],
    ['roleLevel',    :role_level,        :content],
    # A username
    ['updateAuthor', :update_author,     :content],
    ['created',      :create_time,       :to_iso_date],
    ['updated',      :last_updated_time, :to_iso_date]
  )

  # @todo make this method shorter
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
