class TestJIRAService < MiniTest::Unit::TestCase

  def setup; end
  def teardown; end

  def test_token_constructor
    inst = JIRA::JIRAService.instance_with_token 'url', 'user', 'token'
    assert_equal 'url',   inst.instance_variable_get(:@endpoint_url)
    assert_equal 'user',  inst.instance_variable_get(:@user)
    assert_equal 'token', inst.instance_variable_get(:@auth_token)
  end

end
