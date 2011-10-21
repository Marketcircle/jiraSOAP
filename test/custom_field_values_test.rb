class TestCustomFieldValues < MiniTest::Unit::TestCase

  def test_can_initialize_empty
    cv = JIRA::CustomFieldValue.new
    assert_nil cv.id
    assert_empty cv.values
  end

  def test_can_initailize_with_an_id
    id = 'thingamajig'
    cv = JIRA::CustomFieldValue.new id
    assert_equal id, cv.id
    assert_empty cv.values
  end

  def test_can_initialize_with_everthing
    id     = 42
    values = 45
    cv = JIRA::CustomFieldValue.new id, values
    assert_equal id, cv.id
    assert_empty Array(values), cv.values
  end

end
