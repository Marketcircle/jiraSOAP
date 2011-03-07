$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'jiraSOAP'

require 'rubygems'
require 'minitest/autorun'
require 'minitest/pride'
require 'webmock/unit'

class MiniTest::Unit::TestCase
end
