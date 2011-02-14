require 'time'
require 'uri'
require 'nokogiri'

require 'handsoap'
Handsoap.http_driver = :net_http

require 'jiraSOAP/url'
require 'jiraSOAP/handsoap_extensions'
require 'jiraSOAP/nokogiri_extensions'

# All the remote entities as well as the SOAP service client.
module JIRA
end

require 'jiraSOAP/entities'
require 'jiraSOAP/api'
require 'jiraSOAP/JIRAservice'

require 'jiraSOAP/macruby_bonuses' if RUBY_ENGINE == 'macruby'
