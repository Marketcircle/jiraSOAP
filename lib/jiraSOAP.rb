require 'time'
require 'uri'

require 'nokogiri'
require 'jiraSOAP/nokogiri_extensions'

require 'handsoap'
Handsoap.http_driver = :net_http
require 'jiraSOAP/handsoap_extensions'

require 'jiraSOAP/url'
require 'jiraSOAP/macruby_extensions' if RUBY_ENGINE == 'macruby'

##
# All the remote entities as well as the SOAP service client.
module JIRA
end

require 'jiraSOAP/version'
require 'jiraSOAP/entities'
require 'jiraSOAP/api'
require 'jiraSOAP/JIRAservice'
