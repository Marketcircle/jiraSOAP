module JIRA

# Contains a comments body and its metadata.
class Comment < JIRA::DynamicEntity
  add_attributes({
    'author'       => [:original_author=, :to_s],
    'body'         => [:body=,            :to_s],
    'groupLevel'   => [:group_level=,     :to_s],
    'roleLevel'    => [:role_level=,      :to_s],
    'updateAuthor' => [:update_author=,   :to_s],
    'created'      => [:create_date=,     :to_date],
    'updated'      => [:last_updated=,    :to_date]
  })

  # @return [String]
  attr_accessor :original_author

  # @return [String]
  attr_accessor :role_level

  # @return [String]
  attr_accessor :group_level

  # @return [String]
  attr_accessor :body

  # @return [Time]
  attr_accessor :create_date

  # @return [Time]
  attr_accessor :last_updated

  # @return [String]
  attr_accessor :update_author

  # @todo make this method shorter
  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for(msg)
    msg.add 'id', @id
    msg.add 'author', @original_author
    msg.add 'body', @body
    msg.add 'groupLevel', @group_level
    msg.add 'roleLevel', @role_level
    msg.add 'updateAuthor', @update_author
  end
end

end
