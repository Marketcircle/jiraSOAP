module JIRA::RemoteAPI

  ##
  # @note The JIRA SOAP API only works with the metadata for attachments,
  #       you will have to look at your servers configuration to figure
  #       out the proper URL to call to get attachment data.
  #
  # This module has implemented all relevant APIs as of JIRA 4.2.

  # @group Attachments

  ##
  # @todo change method name to reflect that you only get metadata
  #
  # @param [String] issue_key
  # @return [Array<JIRA::Attachment>]
  def attachments_for_issue_with_key issue_key
    array_jira_call JIRA::Attachment, 'getAttachmentsFromIssue', issue_key
  end

  ##
  # @note Expect this method to be slow.
  #
  # Uploads attachments to an issue using the `addBase64EncodedAttachmentsToIssue`
  # SOAP method.
  #
  # The metadata is not automatically refreshed by this method.  To get the
  # updated metadata (e.g., `file_size` and `content_type`), call
  # {RemoteAPI#attachments_for_issue_with_key}.
  #
  # @param [String] issue_key
  # @param [Array<JIRA::Attachment>] attachments files to be uploaded;
  #   their `content` attributes should populated with the data
  # @return [Boolean] true if successful
  def add_attachments_to_issue_with_key issue_key, *attachments
    invoke('soap:addBase64EncodedAttachmentsToIssue') { |msg|
      msg.add 'soap:in0', self.auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2' do |submsg|
        attachments.each { |attachment| submsg.add 'filenames', attachment.filename }
      end
      msg.add 'soap:in3' do |submsg|
        attachments.each { |attachment| submsg.add 'base64EncodedData', [attachment.content].pack('m0') }
      end
    }
    true
  end

  ##
  # @deprecated This will be removed in the next release (either 0.11 or 1.0)
  #
  # (see #add_attachments_to_issue_with_key)
  #
  # @param [String] issue_key
  # @param [Array<String>] filenames array of names for attachments
  # @param [Array<String>] data base64 encoded data for upload
  # @return [Boolean] true if successful, otherwise an exception is raised
  def add_base64_encoded_attachments_to_issue_with_key issue_key, filenames, data
    $stderr.puts <<-EOM
RemoteAPI#add_base64_encoded_attachments_to_issue_with_key is deprecated and will be removed in the next release.
Please use RemoteAPI#add_attachments_to_issue_with_key instead.
    EOM

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

end
