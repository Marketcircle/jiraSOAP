class TestLogin < MiniTest::Unit::TestCase

  def test_returns_token
    assert_match /^[a-zA-Z0-9]+$/, db.login(user, password)
  end

  def test_caches_the_token
    db.login(user, password)
    assert_match /^[a-zA-Z0-9]+$/, db.instance_variable_get(:@auth_token)
  end

  def test_caches_the_user
    db.login(user, password)
    assert_equal user, db.instance_variable_get(:@user)
  end

  def test_aliased
    assert_equal db.method(:login), db.method(:log_in)
  end

end
