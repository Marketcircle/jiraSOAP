# @note These tests will bloat up your server after a while
class TestAddBase64EncodedAttachmentsToIssueWithKey < MiniTest::Unit::TestCase
  setup_usual

  def key
    'JIRA-1'
  end

  def image1
    @image1 ||= "switcheroo-#{Time.now.to_f}.rb"
  end

  def image2
    @image2 ||= "colemak-#{Time.now.to_f}.png"
  end

  def test_returns_true
    assert_equal true,
      db.add_base64_encoded_attachments_to_issue_with_key(key,
                                                          [image1],
                                                          [switcheroo])
  end

  def test_add_one_attachment
    db.add_base64_encoded_attachments_to_issue_with_key(key,
                                                        [image1],
                                                        [switcheroo])
    issue = db.issue_with_key key
    refute_nil issue.attachment_names.find { |x| x == image1 }
  end

  def test_add_two_attachments
    db.add_base64_encoded_attachments_to_issue_with_key(key,
                                                        [image1, image2],
                                                        [switcheroo, colemak])
    issue = db.get_issue_with_key key
    refute_nil issue.attachment_names.find { |x| x == image1 }
    refute_nil issue.attachment_names.find { |x| x == image2 }
  end

  def switcheroo
    <<-EOF
IyEvdXNyL2Jpbi9lbnYgbWFjcnVieQoKZmlsZSA9IElPLnJlYWQoJ0xvY2FsaXphYmxlLnR4dCcp
LnNwbGl0KC9cbi8pLnNlbGVjdCB7IHxsaW5lfCAhbGluZS5tYXRjaCgvOyQvKS5uaWw/IH0uZWFj
aCB7IHxsaW5lfAogIG1hZ2ljID0gbGluZS5tYXRjaCAvIiguKykiXHMrPVxzKyIoLispIjsvdQoK
ICBwdXRzIDw8RU9GCiAgICAgICA8ZGljdD4KICAgICAgICAgICAgICAgPGtleT5DcmVhdGVEYXRl
PC9rZXk+CiAgICAgICAgICAgICAgIDxyZWFsPjEuMDwvcmVhbD4KICAgICAgICAgICAgICAgPGtl
eT5LZXk8L2tleT4KICAgICAgICAgICAgICAgPHN0cmluZz4jeyQxfTwvc3RyaW5nPgogICAgICAg
ICAgICAgICA8a2V5PlZhbHVlPC9rZXk+CiAgICAgICAgICAgICAgIDxzdHJpbmc+I3skMn08L3N0
cmluZz4KICAgICAgIDwvZGljdD4KRU9GCn0K
    EOF
  end

  def colemak
    <<-EOF
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
QyL2DYZVAAAAAElFTkSuQmCC
    EOF
  end

end
