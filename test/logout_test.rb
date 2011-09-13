class TestLogout < MiniTest::Unit::TestCase
  setup_usual

  def test_normal
    db.login user, password
    assert db.logout
  end

  def test_no_session
    # strongly assert is false, not nil
    db.logout
    assert_equal false, db.logout
  end

  def test_unsets_cached_attributes
    db.login user, password
    db.logout
    assert_nil db.instance_variable_get(:@user)
    assert_nil db.auth_token
  end

  def test_aliased
    assert_equal db.method(:logout), db.method(:log_out)
  end

  # override since we logout during the test
  def teardown
  end

end
