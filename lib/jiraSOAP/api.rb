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
module RemoteAPI

  # XPath constant to get a node containing a response array.
  # This could be used for all responses, but is only used in cases where we
  # cannot use a more blunt XPath expression.
  RESPONSE_XPATH = '/node()[1]/node()[1]/node()[1]/node()[2]'

  # @todo change method name to #login! since we are changing internal state?
  # The first method to call; other methods will fail until you are logged in.
  # @param [String] user JIRA user name to login with
  # @param [String] password
  # @return [Boolean]
  def login user, password
    response    = soap_call 'login', user, password
    @auth_token = response.document.xpath('//loginReturn').first.to_s
    @user       = user
    true
  end

  # @todo change method name to #logout! since we are changing internal state?
  # You only need to call this to make an explicit logout; normally, a session
  # will automatically expire after a set time (configured on the server).
  # @return [Boolean] true if successful, otherwise false
  def logout
    jira_call( 'logout' ).document.xpath('//logoutReturn').to_boolean
  end


  private

  # A generic method for calling a SOAP method and soapifying all
  #  the arguments.
  # @param [String] method_name
  # @param [Object] args
  # @return [Handsoap::SoapResponse]
  def soap_call method_name, *args
    invoke("soap:#{method_name}") { |msg|
      for i in 0...args.size
        msg.add "soap:in#{i}", args[i]
      end
    }
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
