module JIRA
module RemoteAPI

  ##
  # This module has implemented all relevant APIs as of JIRA 4.2.
  # @group Avatars

  ##
  # Gets you the default avatar image for a project; if you want all
  # the avatars for a project, use {#get_project_avatars_for_key}.
  #
  # @param [String] project_key
  # @return [JIRA::Avatar]
  def get_project_avatar_for_key project_key
    JIRA::Avatar.new_with_xml jira_call( 'getProjectAvatar', project_key )
  end

  ##
  # Gets ALL avatars for a given project with this method; if you
  # just want the project avatar, use {#get_project_avatar_for_key}.
  # @param [String] project_key
  # @param [Boolean] include_default_avatars
  # @return [Array<JIRA::Avatar>]
  def get_project_avatars_for_key project_key, include_default_avatars = false
    array_jira_call JIRA::Avatar, 'getProjectAvatars', project_key, include_default_avatars
  end

  # @note You cannot delete system avatars
  # @note You need project administration permissions to delete an avatar
  # @param [String] avatar_id
  # @return [Boolean] true if successful
  def delete_project_avatar_with_id avatar_id
    jira_call 'deleteProjectAvatar', avatar_id
    true
  end

  # @note You need project administration permissions to edit an avatar
  # @note JIRA does not care if the avatar_id is valid
  # Change the project avatar to another existing avatar. If you want to
  # upload a new avatar and set it to be the new project avatar use
  # {#set_new_project_avatar_for_project_with_key} instead.
  # @return [Boolean] true if successful
  def set_project_avatar_for_project_with_key project_key, avatar_id
    jira_call 'setProjectAvatar', project_key, avatar_id
    true
  end

  # @note You need project administration permissions to edit an avatar
  # Use this method to create a new custom avatar for a project and set it
  # to be current avatar for the project.
  #
  # The image, provided as base64 encoded data, should be a 48x48 pixel square.
  # If the image is larger, the top left 48 pixels are taken, if it is smaller
  # then it will be upscaled to 48 pixels.
  # The small version of the avatar image (16 pixels) is generated
  # automatically.
  # If you want to switch a project avatar to an avatar that already exists on
  # the system then use {#set_project_avatar_for_project_with_key} instead.
  # @param [String] project_key
  # @param [String] mime_type
  # @param [String] base64_image
  # @return [Boolean] true if successful
  def set_new_project_avatar_for_project_with_key project_key, mime_type, base64_image
    jira_call 'setNewProjectAvatar', project_key, mime_type, base64_image
    true
  end

end
end
