# @todo consider adding a finalizer that will try to logout
# @note HTTPS is not supported in this version.
# Interface to the JIRA endpoint server.
#
# Due to limitations in Handsoap::Service, there can only be one endpoint.
# You can have multiple instances of that one endpoint if you would
# like; but if you try to set a differnt endpoint for a new instance you
# will end up messing up any other instances currently being used.
#
# It is best to treat this class as a singleton, but it is not enforced
# in case you want to be able to login as multiple users to the same endpoint.
class JIRA::JIRAService < Handsoap::Service
  include RemoteAPI

  # @return [String]
  attr_reader :auth_token

  # @return [String]
  attr_reader :user

  # @return [URL]
  attr_reader :endpoint_url

  # Initialize and log in.
  # @param [String,URL] url URL for the JIRA server
  # @param [String] user JIRA user name to login with
  # @param [String] password
  # @return [JIRA::JIRAService]
  def self.instance_with_endpoint url, user, password
    jira = JIRA::JIRAService.new url
    jira.login user, password
    jira
  end

  # @param [String,URL] endpoint_url for the JIRA server
  def initialize endpoint_url
    @endpoint_url = endpoint_url
    JIRA::JIRAService.endpoint({
      uri:"#{endpoint_url.to_s}/rpc/soap/jirasoapservice-v2",
      version:2
    })
  end

  # An extra note for users when things break.
  # @deprecated This will be removed in v1.0 when the API is stable.
  # @return [nil]
  def method_missing method, *args
    message  = "#{method} is not a valid method. Check the documentation; the "
    message << 'API is not stabale yet and the method name likely changed.'
    STDERR.puts message
    super method, *args
  end


  protected

  # Makes sure the correct namespace is set
  def on_create_document doc
    doc.alias 'soap', 'http://soap.rpc.jira.atlassian.com'
  end

  # Make sure that the required namespace is added
  def on_response_document doc
    doc.add_namespace 'jir', @endpoint_url
  end

end
