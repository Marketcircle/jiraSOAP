module JIRA

# Contains a base64 encoded avatar image and metadata about the avatar.
class Avatar < JIRA::DynamicEntity

  # @return [String]
  attr_accessor :owner

  # @return [String] the place where the avatar is used
  attr_accessor :type

  # @return [String]
  attr_accessor :mime_type

  # @return [String]
  attr_accessor :base64_data

  # @return [boolean] indicates if the image is the system default
  attr_accessor :system

  # @return [boolean] true if avatar is the default system avatar, else false
  def system?; @system; end

  # @todo remove the control couple
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    super frag
    @owner, @type, @mime_type, @base64_data, @system =
      frag.nodes( ['owner',       :to_s],
                  ['type',        :to_s],
                  ['contentType', :to_s],
                  ['base64Data',  :to_s],
                  ['system',      :to_boolean] )
  end
end

end
