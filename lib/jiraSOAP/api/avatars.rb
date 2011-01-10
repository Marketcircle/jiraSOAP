module JIRA
module RemoteAPI
  # @group Working with Avatars

  # Gets you the default avatar image for a project; if you want all
  # the avatars for a project, use {#get_project_avatars_for_key}.
  # @param [String] project_key
  # @return [JIRA::Avatar]
  def get_project_avatar_for_key project_key
    response = invoke('soap:getProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    JIRA::Avatar.new_with_xml response.document.xpath('//getProjectAvatarReturn').first
  end

  # Gets ALL avatars for a given project with this method; if you
  # just want the project avatar, use {#get_project_avatar_for_key}.
  # @param [String] project_key
  # @param [true,false] include_default_avatars
  # @return [[JIRA::Avatar]]
  def get_project_avatars_for_key project_key, include_default_avatars = false
    response = invoke('soap:getProjectAvatars') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
      msg.add 'soap:in2', include_default_avatars
    }
    response.document.xpath("#{RESPONSE_XPATH}/getProjectAvatarsReturn").map {
      |frag| JIRA::Avatar.new_with_xml frag
    }
  end

  # @note You cannot delete the system avatar
  # @note You need project administration permissions to delete an avatar
  # @param [#to_s] avatar_id
  # @return [true]
  def delete_project_avatar_with_id avatar_id
    invoke('soap:deleteProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', avatar_id
    }
    true
  end

  # @note You need project administration permissions to edit an avatar
  # @note JIRA does not care if the avatar_id is valid
  # Change the project avatar to another existing avatar. If you want to
  # upload a new avatar and set it to be the new project avatar use
  # {#set_new_project_avatar_for_project_with_key} instead.
  # @return [true]
  def set_project_avatar_for_project_with_key project_key, avatar_id
    invoke('soap:setProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
      msg.add 'soap:in2', avatar_id
    }
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
  # @param [#to_s] base64_image
  # @return [true]
  def set_new_project_avatar_for_project_with_key project_key, mime_type, base64_image
    invoke('soap:setNewProjectAvatar') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
      msg.add 'soap:in2', mime_type
      msg.add 'soap:in3', base64_image
    }
    true
  end

  # @endgroup
end
end
