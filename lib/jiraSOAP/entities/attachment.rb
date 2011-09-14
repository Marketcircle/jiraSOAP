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
  # @note This method does not allow you to read the content of an existing
  #       attachment on the issue; only the metadata for the attachment may
  #       be read at this time.
  #
  # Content to be used for adding attachments, using
  # {RemoteAPI#add_attachments_to_issue_with_key}. Do _not_ base64 encode
  # the data yourself, it will be done for you when the attachment is
  # uploaded.
  #
  # However, attachment data coming from the server will come down in base64
  # encoded format...
  #
  # @return [String]
  attr_accessor :content

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
end

##
# @deprecated This is just an alias, please use {JIRA::Attachment} instead
#
# Just an alias for {JIRA::Attachment}.
JIRA::AttachmentMetadata = JIRA::Attachment
