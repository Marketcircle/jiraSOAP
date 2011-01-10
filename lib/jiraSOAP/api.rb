require 'jiraSOAP/api/users'
require 'jiraSOAP/api/avatars'
require 'jiraSOAP/api/versions'
require 'jiraSOAP/api/projects'
require 'jiraSOAP/api/project_roles'
require 'jiraSOAP/api/schemes'
require 'jiraSOAP/api/issues'
require 'jiraSOAP/api/filters'
require 'jiraSOAP/api/server_info'
require 'jiraSOAP/api/additions'

module JIRA

# Contains the API defined by Atlassian for the [JIRA SOAP service](http://docs.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/soap/JiraSoapService.html).
#
# There are several cases where this API diverges from the one defined by
# Atlassian; most notably, this API tries to be more idomatically Ruby by using
# snake case for method names, default values, varargs, etc..
# @todo logging
# @todo progressWorkflowAction and friends [target v0.7]
module RemoteAPI

  # XPath constant to get a node containing a response array.
  # This could be used for all responses, but is only used in cases where we
  # cannot use a more blunt XPath expression.
  RESPONSE_XPATH = '/node()[1]/node()[1]/node()[1]/node()[2]'

  # The first method to call; other methods will fail until you are logged in.
  # @param [String] user JIRA user name to login with
  # @param [String] password
  # @return [Boolean]
  def login(user, password)
    response = invoke('soap:login') { |msg|
      msg.add 'soap:in0', user
      msg.add 'soap:in1', password
    }
    # cache now that we know it is safe to do so
    @user       = user
    @auth_token = response.document.xpath('//loginReturn').first.to_s
    true
  end

  # You only need to call this to make an explicit logout; normally, a session
  # will automatically expire after a set time (configured on the server).
  # @return [Boolean] true if successful, otherwise false
  def logout
    response = invoke('soap:logout') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath('//logoutReturn').to_boolean
  end

  # @return [[JIRA::Priority]]
  def get_priorities
    response = invoke('soap:getPriorities') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getPrioritiesReturn").map {
      |frag| JIRA::Priority.new_with_xml frag
    }
  end

  # @return [[JIRA::Resolution]]
  def get_resolutions
    response = invoke('soap:getResolutions') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getResolutionsReturn").map {
      |frag| JIRA::Resolution.new_with_xml frag
    }
  end

  # @return [[JIRA::Field]]
  def get_custom_fields
    response = invoke('soap:getCustomFields') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getCustomFieldsReturn").map {
      |frag| JIRA::Field.new_with_xml frag
    }
  end

  # @return [[JIRA::IssueType]]
  def get_issue_types
    response = invoke('soap:getIssueTypes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssueTypesReturn").map {
      |frag| JIRA::IssueType.new_with_xml frag
    }
  end

  # @return [[JIRA::Status]]
  def get_statuses
    response = invoke('soap:getStatuses') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getStatusesReturn").map {
      |frag| JIRA::Status.new_with_xml frag
    }
  end


  # @param [String] issue_key
  # @return [[JIRA::Attachment]]
  def get_attachments_for_issue_with_key(issue_key)
    response = invoke('soap:getAttachmentsFromIssue') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getAttachmentsFromIssueReturn").map {
      |frag| JIRA::AttachmentMetadata.new_with_xml frag
    }
  end

  # @param [String] issue_key
  # @param [JIRA::Comment] comment
  # @return [true]
  def add_comment_to_issue_with_key(issue_key, comment)
    invoke('soap:addComment') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2' do |submsg| comment.soapify_for submsg end
    }
    true
  end

  # @param [String] id
  # @return [JIRA::Comment]
  def get_comment_with_id(id)
    response = invoke('soap:getComment') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', id
    }
    JIRA::Comment.new_with_xml response.document.xpath('//getCommentReturn').first
  end

  # @param [String] issue_key
  # @return [[JIRA::Comment]]
  def get_comments_for_issue_with_key(issue_key)
    response = invoke('soap:getComments') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getCommentsReturn").map {
      |frag| JIRA::Comment.new_with_xml frag
    }
  end

  # @param [JIRA::Comment] comment
  # @return [JIRA::Comment]
  def update_comment(comment)
    response = invoke('soap:editComment') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| comment.soapify_for submsg end
    }
    frag = response.document.xpath('//editCommentReturn').first
    JIRA::Comment.new_with_xml frag
  end

  # @return [[JIRA::IssueType]]
  def get_subtask_issue_types
    response = invoke('soap:getSubTaskIssueTypes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getSubTaskIssueTypesReturn").map {
      |frag| JIRA::IssueType.new_with_xml frag
    }
  end

  # @param [String] project_id
  # @return [[JIRA::IssueType]]
  def get_subtask_issue_types_for_project_with_id(project_id)
    response = invoke('soap:getSubTaskIssueTypesForProject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_id
    }
    response.document.xpath("#{RESPONSE_XPATH}/getSubtaskIssueTypesForProjectReturn").map {
      |frag| JIRA::IssueType.new_with_xml frag
    }
  end

  # I have no idea what this method does.
  # @todo find out what this method does
  # @return [true]
  def refresh_custom_fields
    invoke('soap:refreshCustomFields') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    true
  end

  # @todo optimize building the message, try a single pass
  # Expect this method to be slow.
  # @param [String] issue_key
  # @param [[String]] filenames names to put on the files
  # @param [[String]] data base64 encoded data
  # @return [true]
  def add_base64_encoded_attachments_to_issue_with_key(issue_key, filenames, data)
    invoke('soap:addBase64EncodedAttachmentsToIssue') { |msg|
      msg.add 'soap:in0', @auth_token
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

  # @param [#to_s] issue_id
  # @return [Time]
  def get_resolution_date_for_issue_with_id issue_id
    response = invoke('soap:getResolutionDateById') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_id
    }
    response.document.xpath('//getResolutionDateByIdReturn').to_date
  end

  # @param [String] issue_key
  # @return [Time]
  def get_resolution_date_for_issue_with_key issue_key
    response = invoke('soap:getResolutionDateByKey') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    response.document.xpath('//getResolutionDateByKeyReturn').to_date
  end

end

end
