##
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

  # @todo are there any other cases when we need to build
  #  a message from a comment and include the create_time
  #  or update_time?
  # These are things we should not include when building
  # a SOAP message to create a comment
  @build.delete 'created'
  @build.delete 'updated'
end
