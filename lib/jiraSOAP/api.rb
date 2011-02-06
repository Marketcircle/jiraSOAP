require 'jiraSOAP/api/users'
require 'jiraSOAP/api/avatars'
require 'jiraSOAP/api/versions'
require 'jiraSOAP/api/projects'
require 'jiraSOAP/api/project_roles'
require 'jiraSOAP/api/schemes'
require 'jiraSOAP/api/issues'
require 'jiraSOAP/api/filters'
require 'jiraSOAP/api/server_info'
require 'jiraSOAP/api/attachments'
require 'jiraSOAP/api/comments'
require 'jiraSOAP/api/issue_data_types'
require 'jiraSOAP/api/additions'

module JIRA

# Contains the API defined by Atlassian for the [JIRA SOAP service](http://docs.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/soap/JiraSoapService.html).
#
# There are several cases where this API diverges from the one defined by
# Atlassian; most notably, this API tries to be more idomatically Ruby by using
# snake case for method names, default values, varargs, etc..
# @todo logging
# @todo progressWorkflowAction and friends [target v0.7]
# @todo get Nokogiri element directly
# @todo extend nokogiri class
# @todo instead of #map, try using a loop over #children.size
module RemoteAPI

  # XPath constant to get a node containing a response array.
  # This could be used for all responses, but is only used in cases where we
  # cannot use a more blunt XPath expression.
  RESPONSE_XPATH = '/node()[1]/node()[1]/node()[1]/node()[2]'

  # @todo change method name to #login! since we are changing internal state?
  # The first method to call; other methods will fail until you are logged in.
  # @param [String] user JIRA user name to login with
  # @param [String] password
  # @return [Boolean] true if successful
  def login username, password
    response = invoke('soap:login') { |msg|
      msg.add 'soap:in0', username
      msg.add 'soap:in1', password
    }
    @auth_token = response.document.xpath('//loginReturn').first.to_s
    @user       = user
    true
  end

  # @todo change method name to #logout! since we are changing internal state?
  # You only need to call this to make an explicit logout; normally, a session
  # will automatically expire after a set time (configured on the server).
  # @return [Boolean] true if successful, otherwise false
  def logout
    jira_call( 'logout' ).to_boolean
  end


  private

  # A generic method for calling a SOAP method and soapifying all
  # the arguments.
  # @param [String] method_name
  # @param [Object] *args
  # @return [Handsoap::XmlQueryFront::NodeSelection]
  def jira_call method_name, *args
    response = invoke("soap:#{method_name}") { |msg|
      msg.add 'soap:in0', @auth_token
      for i in 1..args.size
        msg.add "soap:in#{i}", args.shift
      end
    }
    response.document.xpath "#{RESPONSE_XPATH}/#{method_name}Return"
  end

  # A wrapper around soap_call to add the @auth_token.
  # @param [String] method_name
  # @param [Object] args
  # @return [Handsoap::SoapResponse]
  def jira_call method_name, *args
    soap_call method_name, @auth_token, *args
  end

end

end
