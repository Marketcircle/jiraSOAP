# @todo find out what the id value of @owner relates to
# Contains a base64 encoded avatar image and metadata about the avatar.
class JIRA::Avatar < JIRA::DynamicEntity
  add_attributes(
    # This seems to be an id ref to some other object
    ['owner',       :owner,       :content],
    # The place where the avatar is used (e.g. 'project')
    ['type',        :type,        :content],
    ['contentType', :mime_type,   :content],
    ['base64Data',  :base64_data, :content],
    # Indicates if the image is the system default
    ['system',      :system,      :to_boolean]
  )
end
