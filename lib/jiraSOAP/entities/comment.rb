module JIRA

# Contains a comments body and its metadata.
class Comment < JIRA::DynamicEntity

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

  # @todo remove the control couple
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    super frag
    @original_author, @body, @group_level, @role_level,
    @update_author, @create_date, @last_updated =
      frag.nodes( ['author',       :to_s],
                  ['body',         :to_s],
                  ['groupLevel',   :to_s],
                  ['roleLevel',    :to_s],
                  ['updateAuthor', :to_s],
                  ['created',      :to_date],
                  ['updated',      :to_date] )
  end

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
