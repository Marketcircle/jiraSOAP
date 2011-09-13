class TestLogout < MiniTest::Unit::TestCase
  setup_usual

  def test_normal
    db.login user, password
    assert db.logout
  end

  def test_no_session
    # strongly assert is false, not nil
    assert_equal false, db.logout
  end

  def test_aliased
    assert_equal db.method(:logout), db.method(:log_out)
  end

  # override since we logout during the test
  def teardown
  end

end
