module JIRA
class JIRAService < Handsoap::Service
  include  RemoteAPI

  attr_reader   :authToken
  attr_accessor :log

  def self.instanceAtURL(url, user, password, logLevel = Logger::WARN)
    jira = JIRAService.new url
    jira.log.level = logLevel
    jira.login user, password
    jira
  end

  def initialize(endpointURL)
    @endpointURL = endpointURL

    super

    endpoint_data = {
      :uri => "#{endpointURL}/rpc/soap/jirasoapservice-v2",
      :version => 2
    }
    self.class.endpoint endpoint_data

    @log = Logger.new STDOUT
  end

  #PONDER: a finalizer that will try to logout

  protected
  def on_create_document(doc)
    doc.alias 'soap', 'http://soap.rpc.jira.atlassian.com'
  end
  def on_response_document(doc)
    doc.add_namespace 'jir', @endpointURL
  end
end
end
