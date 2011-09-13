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

  def self.setup_usual
    define_method :setup do
      db.login user, password
    end
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


basic  = ['login_test', 'logout_test']
create = ['attachments_test']
read   = basic + []
update = []
delete = []
all    = basic + create + read + update + delete

# Look at environment variables to decide which tests to run
tests = case ENV['JIRASOAP']
when 'all'    then all
when 'basic'  then basic
when 'create' then create
when 'read'   then read
when 'update' then update
when 'delete' then delete
else read # hmm, for safeties sake, but maybe it should be all...
end
tests.each do |test| require test end
