##
# Contains a comment's body and metadata.
class JIRA::Comment < JIRA::DynamicEntity

  # @return [String] A username
  add_attribute :author, 'author', :content

  # @return [String]
  add_attribute :body, 'body', :content

  # @return [String]
  add_attribute :group_level, 'groupLevel', :content

  # @return [String]
  add_attribute :role_level, 'roleLevel', :content

  # @return [String] A username
  add_attribute :update_author, 'updateAuthor', :content

  # @return [Time]
  add_attribute :create_time, 'created', :to_iso_date

  # @return [Time]
  add_attribute :last_updated_time, 'updated', :to_iso_date

  # @todo are there any other cases when we need to build
  #  a message from a comment and include the create_time
  #  or update_time?
  # These are things we should not include when building
  # a SOAP message to create a comment
  @build.delete 'created'
  @build.delete 'updated'

  ##
  # Add a created comment to an issue
  def add_to issue_key
    raise NotImplementedError
  end
end
