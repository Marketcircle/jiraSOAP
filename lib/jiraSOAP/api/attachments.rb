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
  deprecate :attachments_for_issue_with_key

  ##
  # Uploads attachments to an issue using the addBase64EncodedAttachmentsToIssue SOAP method
  # Expect this method to be slow.
  #
  # @param [String] issue_key
  # @param [Array<JIRA::Attachment>] attachments files to be uploaded.  Their :content attributes should populated with the data
  # @return [Boolean] true if successful
  def add_attachments_to_issue_with_key issue_key,*attachments
    invoke('soap:addBase64EncodedAttachmentsToIssue') { |msg|
      msg.add 'soap:in0', self.auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2' do |submsg|
        attachments.each { |attachment| submsg.add 'filenames', attachment.filename }
      end
      msg.add 'soap:in3' do |submsg|
        attachments.each { |attachment| submsg.add 'base64EncodedData', [attachment.content].pack("m0") }
      end
    }
    true
  end

end
