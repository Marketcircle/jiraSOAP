##
# Only contains the metadata for an attachment. The URI for an attachment
# appears to be of the form
# "{JIRA::JIRAService.endpoint_url}/secure/attachment/{#id}/{#file_name}"
class JIRA::AttachmentMetadata < JIRA::NamedEntity
  add_attributes(
    ['author',   :author,      :content],
    ['filename', :file_name,   :content],
    ['mimetype', :mime_type,   :content],
    # Measured in bytes
    ['filesize', :file_size,   :to_i],
    ['created',  :create_time, :to_iso_date]
  )

  ##
  # Fetch the attachment from the server.
  def attachment
    raise NotImplementedError
  end

  # @todo I suspect that I would have to not upload
  # create_time, author
end
