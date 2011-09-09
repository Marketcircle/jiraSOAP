##
# Only contains the metadata for an attachment. The URI for an attachment
# appears to be of the form
# "{JIRA::JIRAService.endpoint_url}/secure/attachment/{#id}/{#file_name}"
class JIRA::Attachment < JIRA::NamedEntity

  # @return [String]
  add_attribute :author, 'author', :content

  # @return [String]
  add_attribute :file_name, 'filename', :content
  alias_method :filename, :file_name
  alias_method :filename=, :file_name=

  # @return [String]
  add_attribute :file_name, 'filename', :content

  ##
  # Content to be used for adding attachments, using #add_attachments_to_issue_with_key
  #
  # Note that this method does not allow you to read the content of an existing attachment on the issue; only the
  # metadata for the attachment may be read at this time.
  #
  # @return [String]
  add_attribute :content, nil, :content

  # @return [String]
  add_attribute :mime_type, 'mimetype', :content
  alias_method :content_type, :mime_type
  alias_method :content_type=, :mime_type=

  ##
  # Measured in bytes
  #
  # @return [Number]
  add_attribute :file_size, 'filesize', :to_i

  # @return [Time]
  add_attribute :create_time, 'created', :to_iso_date

  ##
  # Fetch the attachment from the server.
  def attachment
    raise NotImplementedError, 'Please implement me. :('
  end

  ##
  # Generate a SOAP message fragment for the object.
  #
  # @param [Handsoap::XmlMason::Node] msg SOAP message to add the object to
  # @param [String] label tag name used in wrapping tags
  # @return [Handsoap::XmlMason::Element]
  def soapify_for msg
    debugger
    msg.add "fileNames", do |submsg|
      submsg.add "fileNames", @filename
    end
    msg.add "base64EncodedAttachmentData" do |submsg|
      submsg.add "base64EncodedAttachmentData", [@content].pack("m")
    end
  end

end
