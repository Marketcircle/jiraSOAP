class TestWorklog < MiniTest::Unit::TestCase

  def setup;    end
  def teardown; end

  def test_no_typos
    w = JIRA::Worklog.new

    assert_respond_to w, :comment
    assert_respond_to w, :start_date
    assert_respond_to w, :time_spent
  end

end
