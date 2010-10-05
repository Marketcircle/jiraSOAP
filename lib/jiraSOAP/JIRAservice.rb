module JIRA
class JIRAService < Handsoap::Service
  include RemoteAPI

  attr_reader :auth_token, :user

  def self.instance_at_url(url, user, password)
    jira = JIRAService.new url
    jira.login user, password
    jira
  end

  def initialize(endpoint_url)
    super

    @endpoint_url = endpoint_url
    endpoint_data = {
      :uri => "#{endpoint_url}/rpc/soap/jirasoapservice-v2",
      :version => 2
    }
    self.class.endpoint endpoint_data
  end

  #PONDER: a finalizer that will try to logout

  def method_missing(method, *args)
    $stderr.puts "#{method} is not a defined method in the API...yet"
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
