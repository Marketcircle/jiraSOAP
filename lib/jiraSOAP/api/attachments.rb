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
  # @return [Array<JIRA::AttachmentMetadata>]
  def attachments_for_issue_with_key issue_key
    array_jira_call JIRA::AttachmentMetadata, 'getAttachmentsFromIssue', issue_key
  end
  alias_method :get_attachments_for_issue_with_key, :attachments_for_issue_with_key

  ##
  # Expect this method to be slow.
  #
  # @param [String] issue_key
  # @param [Array<String>] filenames names to put on the files
  # @param [Array<String>] data base64 encoded data
  # @return [Boolean] true if successful
  def add_base64_encoded_attachments_to_issue_with_key issue_key, filenames, data
    jira_call 'addBase64EncodedAttachmentsToIssue', issue_key, filenames, data
    true
  end

end
