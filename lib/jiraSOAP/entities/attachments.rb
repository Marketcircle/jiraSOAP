module JIRA

# Only contains the metadata for an attachment. The URI for an attachment
# appears to be of the form
# "{JIRA::JIRAService.endpoint_url}/secure/attachment/{#id}/{#filename}"
class AttachmentMetadata < JIRA::NamedEntity

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

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
    @author, @filename, @mime_type, @file_size, @create_date =
      frag.nodes( ['author',   :to_s],
                  ['filename', :to_s],
                  ['mimetype', :to_s],
                  ['filesize', :to_i],
                  ['created',  :to_date] )
  end
end

end
