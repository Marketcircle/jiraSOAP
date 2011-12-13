require 'jiraSOAP'

require 'rubygems'
gem 'minitest', '~> 2.5'
require 'minitest/autorun'
require 'minitest/pride'

class MiniTest::Unit::TestCase

  def user
    'marada'
  end

  def password
    'test'
  end

  def host
    'http://169.254.199.62:8080'
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


offline = ['worklog_test']
basic   = ['login_test', 'logout_test', 'custom_field_values_test', 'worklog_test']
create  = ['attachments_test']
read    = basic + []
update  = []
delete  = []
all     = basic + create + read + update + delete

# Look at environment variables to decide which tests to run
tests = case ENV['JIRASOAP']
when 'all'     then all
when 'basic'   then basic
when 'create'  then create
when 'read'    then read
when 'update'  then update
when 'delete'  then delete
when 'offline' then offline
else read # hmm, for safeties sake, but maybe it should be all...
end
tests.each do |test| require test end
