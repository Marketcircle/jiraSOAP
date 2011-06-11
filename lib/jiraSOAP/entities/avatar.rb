##
# @todo find out what the id value of @owner relates to
#
# Contains a base64 encoded avatar image and metadata about the avatar.
class JIRA::Avatar < JIRA::DynamicEntity

  ##
  # This seems to be an id ref to some other object
  #
  # @return [String]
  add_attribute :owner, 'owner', :content

  ##
  # The place where the avatar is used (e.g. 'project')
  #
  # @return [String]
  add_attribute :type, 'type', :content

  # @return [String]
  add_attribute :mime_type, 'contentType', :content
  alias_method :content_type, :mime_type

  # @return [String]
  add_attribute :base64_data, 'base64Data', :content
  alias_method :data, :base64_data

  ##
  # Indicates if the image is the system default
  #
  # @return [Boolean]
  add_attribute :system, 'system', :to_boolean

end
