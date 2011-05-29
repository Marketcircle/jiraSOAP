##
# Failed logins cause errors to be raised, which is handled by handsoap.
class TestRemoteAPILogin < MiniTest::Unit::TestCase

  AUTH_TOKEN = 'c7VHkf5Nw0'

  def test_login_returns_auth_token
    mock_response successful_login
    ret = @db.login 'test', 'test'

    assert_instance_of String, ret
    assert_equal AUTH_TOKEN, ret
  end

  def successful_login
    <<-EOB
<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://www.w3.org/2003/05/soap-envelope" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><ns1:loginResponse soapenv:encodingStyle="http://www.w3.org/2003/05/soap-encoding" xmlns:ns1="http://soap.rpc.jira.atlassian.com"><ns2:result xmlns:ns2="http://www.w3.org/2003/05/soap-rpc">loginReturn</ns2:result><loginReturn xsi:type="xsd:string">#{AUTH_TOKEN}</loginReturn></ns1:loginResponse></soapenv:Body></soapenv:Envelope>
    EOB
  end

end
