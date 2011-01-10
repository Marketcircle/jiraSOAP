module JIRA
module RemoteAPI
  # @group Working with Comments

  # @param [String] issue_key
  # @param [JIRA::Comment] comment
  # @return [true]
  def add_comment_to_issue_with_key issue_key, comment
    invoke('soap:addComment') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
      msg.add 'soap:in2' do |submsg| comment.soapify_for submsg end
    }
    true
  end

  # @param [String] id
  # @return [JIRA::Comment]
  def get_comment_with_id id
    response = invoke('soap:getComment') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', id
    }
    JIRA::Comment.new_with_xml response.document.xpath('//getCommentReturn').first
  end

  # @param [String] issue_key
  # @return [[JIRA::Comment]]
  def get_comments_for_issue_with_key issue_key
    response = invoke('soap:getComments') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', issue_key
    }
    response.document.xpath("#{RESPONSE_XPATH}/getCommentsReturn").map {
      |frag| JIRA::Comment.new_with_xml frag
    }
  end

  # @param [JIRA::Comment] comment
  # @return [JIRA::Comment]
  def update_comment comment
    response = invoke('soap:editComment') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| comment.soapify_for submsg end
    }
    frag = response.document.xpath('//editCommentReturn').first
    JIRA::Comment.new_with_xml frag
  end

  # @endgroup
end
end
