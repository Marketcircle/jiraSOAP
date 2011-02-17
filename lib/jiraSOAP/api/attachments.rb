module JIRA
module RemoteAPI
  # @group Working with issue Attachments and their metadata

  # @todo change method name to reflect that you only get metadata
  # @param [String] issue_key
  # @return [Array<JIRA::AttachmentMetadata>]
  def get_attachments_for_issue_with_key issue_key
    jira_call JIRA::AttachmentMetadata, 'getAttachmentsFromIssue', issue_key
  end

  # Expect this method to be slow.
  # @param [String] issue_key
  # @param [Array<String>] filenames names to put on the files
  # @param [Array<String>] data base64 encoded data
  # @return [Boolean] true if successful
  def add_base64_encoded_attachments_to_issue_with_key issue_key, filenames, data
    invoke('soap:addBase64EncodedAttachmentsToIssue') { |msg|
      msg.add 'soap:in0', self.auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2' do |submsg|
        filenames.each { |filename| submsg.add 'filenames', filename }
      end
      msg.add 'soap:in3' do |submsg|
        data.each { |datum| submsg.add 'base64EncodedData', datum }
      end
    }
    true
  end

  # @endgroup
end
end
