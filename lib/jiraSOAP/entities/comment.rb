module JIRA

# Contains a comments body and its metadata.
class Comment < JIRA::DynamicEntity
  add_attributes({
    'author'       => [:author=,            :to_s],
    'body'         => [:body=,              :to_s],
    'groupLevel'   => [:group_level=,       :to_s],
    'roleLevel'    => [:role_level=,        :to_s],
    'updateAuthor' => [:update_author=,     :to_s],
    'created'      => [:create_time=,       :to_date],
    'updated'      => [:last_updated_time=, :to_date]
  })

  # @return [String] a username
  attr_accessor :author

  # @return [String]
  attr_accessor :role_level

  # @return [String]
  attr_accessor :group_level

  # @return [String]
  attr_accessor :body

  # @return [Time]
  attr_accessor :create_time

  # @return [Time]
  attr_accessor :last_updated_time

  # @return [String] a username
  attr_accessor :update_author

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

end
