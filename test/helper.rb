$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jiraSOAP'

require 'rubygems'
if RUBY_ENGINE == 'macruby'
  gem 'minitest-macruby-pride', '>= 2.2.0'
elsif RUBY_VERSION == '1.9.2'
  gem 'minitest', '>= 2.1.0'
end

require 'minitest/autorun'
require 'minitest/pride'

class MiniTest::Unit::TestCase
  ENDPOINT = 'http://bugs.atlassian.com:8080'

  def setup
    @db = JIRA::JIRAService.new ENDPOINT
  end

  def mock_response body, status_code = 200
    Handsoap::Http.drivers[:mock] =
      Handsoap::Http::Drivers::MockDriver.new content:body, status:status_code, headers:{}
    Handsoap.http_driver = :mock
  end
end
