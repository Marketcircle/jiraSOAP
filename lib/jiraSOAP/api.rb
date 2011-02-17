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
# @todo progressWorkflowAction and friends [target v0.8]
# @todo remove the get_ prefix from api methods that don't need them
# @todo monkey patch Array to include a #to_soap method
module RemoteAPI

  # @group Logging in/out

  # @todo change method name to #login! since we are changing internal state?
  # The first method to call; other methods will fail until you are logged in.
  # @param [String] user JIRA user name to login with
  # @param [String] password
  # @return [String] auth_token if successful, otherwise raises an exception
  def login username, password
    response    = build 'login', username, password
    self.auth_token = response.document.element./(RESPONSE_XPATH).first.content
    @user       = user
    self.auth_token
  end

  # @todo change method name to #logout! since we are changing internal state?
  # You only need to call this to make an explicit logout; normally, a session
  # will automatically expire after a set time (configured on the server).
  # @return [Boolean] true if successful, otherwise false
  def logout
    call( 'logout' ).to_boolean
  end

  # @endgroup

  private

  # @todo make this method less ugly
  # @todo double check the return type
  # XPath constant to get a node containing a response data.
  RESPONSE_XPATH = '/node()[1]/node()[1]/node()[1]/node()[2]'

  # A generic method for calling a SOAP method and soapifying all
  # the arguments, adapted for usage with jiraSOAP.
  # @param [String] method
  # @param [Object] *args
  # @return [Handsoap::Response]
  def build method, *args
    invoke "soap:#{method}" do |msg|
      for i in 0...args.size
        arg = args.shift
        case arg
        when JIRA::Entity
          msg.add "soap:in#{i}", do |submsg| arg.soapify_for submsg end
        else
          msg.add "soap:in#{i}", arg
        end
      end
    end
  end

  # @todo find a less blunt XPath expression
  # A simple call, for methods that will return a single object.
  # @param [String] method
  # @param [Object] *args
  # @return [Handsoap::XmlQueryFront::NodeSelection]
  def call method, *args
    response = build method, self.auth_token, *args
    response .document.element/("#{RESPONSE_XPATH}/#{method}Return").first
  end

  # A more complex form of {#call} that does a little more work for
  # you when you need to build an array of return values.
  # @param [String] method
  # @param [Object] *args
  # @return [Handsoap::XmlQueryFront::NodeSelection]
  def jira_call type, method, *args
    response = build method, self.auth_token, *args
    frags    = response.document.element/"#{RESPONSE_XPATH}/#{method}Return"
    frags.map { |frag| type.new_with_xml frag }
  end

end

end
