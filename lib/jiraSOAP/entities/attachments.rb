module JIRA

# Only contains the metadata for an attachment. The URI for an attachment
# appears to be of the form
# "{JIRA::JIRAService.endpoint_url}/secure/attachment/{#id}/{#filename}"
class AttachmentMetadata < JIRA::NamedEntity

  @attributes = ancestors[1].attributes
  @attributes.update({
    'author'   => [:author=,      :to_s],
    'filename' => [:filename=,    :to_s],
    'mimetype' => [:mime_type=,   :to_s],
    'filesize' => [:file_size=,   :to_i],
    'created'  => [:create_date=, :to_date],
  })

  # @return [String]
  attr_accessor :author

  # @return [Time]
  attr_accessor :create_date

  # @return [String]
  attr_accessor :filename

  # @return [Fixnum] measured in bytes
  attr_accessor :file_size

  # @return [String]
  attr_accessor :mime_type

end

end
