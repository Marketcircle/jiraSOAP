#TODO: set a requirement on the handsoap version
require 'handsoap'
require 'logger'
require 'time'

require 'jiraSOAP/handsoap_extensions.rb'
require 'jiraSOAP/remoteEntities.rb'
require 'jiraSOAP/remoteAPI.rb'

require 'jiraSOAP/JIRAservice.rb'

#overrides and additions
require 'lib/macruby_stuff.rb' if RUBY_ENGINE == 'macruby'
