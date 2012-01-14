##
# @note HTTPS is not supported out of the box in this version.
#
# Interface to the JIRA endpoint server.
#
# Due to limitations in Handsoap::Service, there can only be one endpoint.
# You can have multiple instances of that one endpoint if you would
# like (different users); but if you try to set a differnt endpoint for a
# new instance you will end up messing up any other instances currently
# being used.
class JIRA::JIRAService < Handsoap::Service
  include JIRA::RemoteAPI
  include JIRA::RemoteAPIAdditions

  # @return [String]
  attr_reader :auth_token

  # @return [String]
  attr_reader :user

  # @return [String]
  attr_reader :endpoint_url

  class << self
    ##
    # Expose endpoint URL
    #
    # @return [String]
    def endpoint_url
      @@endpoint_url
    end
  end

  ##
  # Initialize _and_ log in. Fancy.
  #
  # @param [String,URI::HTTP,NSURL] url URL for the JIRA server
  # @param [String] user JIRA user name to login with
  # @param [String] password
  # @return [JIRA::JIRAService]
  def self.instance_with_endpoint url, user, password
    jira = JIRA::JIRAService.new url
    jira.login user, password
    jira
  end

  # @param [String,URI::HTTP,NSURL] endpoint for the JIRA server
  def initialize endpoint
    @@endpoint_url = @endpoint_url = endpoint.to_s
    self.class.endpoint({
      :uri => "#{endpoint_url}/rpc/soap/jirasoapservice-v2",
      :version => 2
    })
  end


  protected

  ##
  # Makes sure the correct namespace is set
  def on_create_document doc
    doc.alias 'soap', 'http://soap.rpc.jira.atlassian.com'
  end

  ##
  # Make sure that the required namespace is added
  def on_response_document doc
    doc.add_namespace 'jir', @endpoint_url
  end

end
