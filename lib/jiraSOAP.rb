#TODO: set a requirement on the handsoap version
require 'handsoap'
require 'logger'

require 'jiraSOAP/remoteEntities.rb'
require 'jiraSOAP/remoteAPI.rb'

require 'jiraSOAP/JIRAservice.rb'

#overrides and additions
require 'lib/macruby_stuff.rb' if RUBY_ENGINE == 'macruby'
