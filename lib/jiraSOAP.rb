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
module JIRA; end

##
# Inspired by Gem::Deprecate from rubygems.
module JIRA::Deprecate

  def deprecate name
    define_method "get_#{name}" do |*args|
      $stderr.puts <<-EOM
RemoteAPI#get_#{name} is deprecated and will be removed in the next release.
Please use RemoteAPI#{name} instead.
      EOM
      send name, *args
    end
  end

end

require 'jiraSOAP/version'
require 'jiraSOAP/core_extensions'
require 'jiraSOAP/entities'
require 'jiraSOAP/api'
require 'jiraSOAP/jira_service'
