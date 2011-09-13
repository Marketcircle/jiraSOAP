require 'jiraSOAP'

require 'rubygems'
gem 'minitest', '~> 2.5'
require 'minitest/autorun'
require 'minitest/pride'

class MiniTest::Unit::TestCase

  def user
    'mrada'
  end

  def password
    'test'
  end

  def host
    'http://localhost:8808'
  end

  def db
    @db ||= JIRA::JIRAService.new host
  end

  def setup_usual
    db.login user, password
  end

  def self.setup_usual
    define_method :setup do setup_usual end
  end

  def teardown
    db.logout
  end

  def assert_instance_of_boolean value, msg = nil
    if value == true || value == false
      assert true
    else
      msg = "Expected #{mu_pp(value)} to be a boolean" unless msg
      assert false, msg
    end
  end

end
