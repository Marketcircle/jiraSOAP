# Contains a comments body and its metadata.
class JIRA::Comment < JIRA::DynamicEntity
  add_attributes(
    # a username
    ['author',       :author,            :to_s],
    ['body',         :body,              :to_s],
    ['groupLevel',   :group_level,       :to_s],
    ['roleLevel',    :role_level,        :to_s],
    # a username
    ['updateAuthor', :update_author,     :to_s],
    ['created',      :create_time,       :to_date],
    ['updated',      :last_updated_time, :to_date]
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
