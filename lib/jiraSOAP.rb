require 'logger'
require 'time'
require 'uri'

require 'handsoap'
Handsoap.http_driver = :net_http

require 'jiraSOAP/url.rb'
require 'jiraSOAP/handsoap_extensions.rb'
require 'jiraSOAP/remoteEntities.rb'
require 'jiraSOAP/remoteAPI.rb'

require 'jiraSOAP/JIRAservice.rb'

#overrides and additions
require 'lib/jiraSOAP/macruby_bonuses.rb' if RUBY_ENGINE == 'macruby'
