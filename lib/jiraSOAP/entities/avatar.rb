# @todo find out what the id value of @owner relates to
# Contains a base64 encoded avatar image and metadata about the avatar.
class JIRA::Avatar < JIRA::DynamicEntity
  add_attributes(
    # this seems to be an id ref to some other object
    ['owner',       :owner,       :to_s],
    # the place where the avatar is used (e.g. 'project')
    ['type',        :type,        :to_string],
    ['contentType', :mime_type,   :to_string],
    ['base64Data',  :base64_data, :to_string],
    # indicates if the image is the system default
    ['system',      :system,      :to_boolean]
  )
end
