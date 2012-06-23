require 'time'
require 'uri'

require 'nokogiri'
require 'jiraSOAP/nokogiri_extensions'

require 'handsoap'
#Handsoap.http_driver = :http_client
Handsoap.http_driver = :net_http
require 'jiraSOAP/handsoap_extensions'

require 'jiraSOAP/url'

##
# All the remote entities as well as the SOAP service client.
module JIRA; end

require 'jiraSOAP/version'
require 'jiraSOAP/core_extensions'
require 'jiraSOAP/entities'
require 'jiraSOAP/api'
require 'jiraSOAP/jira_service'

if defined? RUBY_ENGINE && RUBY_ENGINE == 'macruby'
  require 'jiraSOAP/macruby_extensions'
end
