# Only contains the metadata for an attachment. The URI for an attachment
# appears to be of the form
# "{JIRA::JIRAService.endpoint_url}/secure/attachment/{#id}/{#file_name}"
class JIRA::AttachmentMetadata < JIRA::NamedEntity
  add_attributes({
    'author'   => [:author=,      :to_s],
    'filename' => [:file_name=,   :to_s],
    'mimetype' => [:mime_type=,   :to_s],
    'filesize' => [:file_size=,   :to_i],
    'created'  => [:create_time=, :to_date],
  })

  # @return [String]
  attr_accessor :author

  # @return [Time]
  attr_accessor :create_time

  # @return [String]
  attr_accessor :file_name

  # @return [Fixnum] measured in bytes
  attr_accessor :file_size

  # @return [String]
  attr_accessor :mime_type
end
