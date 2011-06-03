##
# @todo find out what the id value of @owner relates to
#
# Contains a base64 encoded avatar image and metadata about the avatar.
class JIRA::Avatar < JIRA::DynamicEntity

  # @return [String] This seems to be an id ref to some other object
  add_attribute :owner, 'owner', :content

  # @return [String] The place where the avatar is used (e.g. 'project')
  add_attribute :type, 'type', :content

  # @return [String]
  add_attribute :mime_type, 'contentType', :content
  alias_method :content_type, :mime_type

  # @return [String]
  add_attribute :base64_data, 'base64Data', :content
  alias_method :data, :base64_data

  # @return [Boolean] Indicates if the image is the system default
  add_attribute :system, 'system', :to_boolean

  # @todo I suspect that I will have to remove
  # system, owner

end
