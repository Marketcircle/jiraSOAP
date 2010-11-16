# All the remote entities as well as the SOAP service client.
module JIRA

# Interface to the JIRA endpoint server; set at initialization.
#
# Due to limitations in Handsoap::Service, there can only be one endpoint.
# You can have multiple instances of that one endpoint if you would
# like; but if you try to set a differnt endpoint for a new instance you
# will end up messing up any other instances currently being used.
#
# It is best to treat this class as a singleton. There should only be one.
# However, this is not enforced, in case you want to be able to login as
# multiple users to the same endpoint.
#
# HTTPS is not supported in this version.
#
# @todo consider adding a finalizer that will try to logout
class JIRAService < Handsoap::Service
  include RemoteAPI

  # @return [String]
  attr_reader :auth_token

  # @return [String]
  attr_reader :user

  # @return [String]
  attr_reader :endpoint_url

  # Factory method to initialize and login.
  # @param [String] url URL for the JIRA server
  # @param [String] user JIRA user name to login with
  # @param [String] password
  # @return [JIRA::JIRAService]
  def self.instance_with_endpoint(url, user, password)
    jira = JIRAService.new url
    jira.login user, password
    jira
  end

  # Slightly hacky in order to set the endpoint at the initialization.
  # @param endpoint_url URL for the JIRA server
  def initialize(endpoint_url)
    super

    @endpoint_url = endpoint_url
    endpoint_data = {
      :uri => "#{endpoint_url}/rpc/soap/jirasoapservice-v2",
      :version => 2
    }
    self.class.endpoint endpoint_data
  end

  # Something to help users out until the rest of the API is implemented.
  # @return [nil]
  def method_missing(method, *args)
    message  = "#{method} is not a valid method. Check the documentation; the "
    message << 'method may not be implemented or has changed in recent '
    message << 'revisions. The API has not been stabilized yet.'
    raise NoMethodError.new, message, caller
  end

  protected
  def on_create_document(doc)
    doc.alias 'soap', 'http://soap.rpc.jira.atlassian.com'
  end
  def on_response_document(doc)
    doc.add_namespace 'jir', @endpoint_url
  end
end
end
