module JIRA
module RemoteAPI
  # @group Working with Comments

  # @param [String] issue_key
  # @param [JIRA::Comment] comment
  # @return [Boolean] true if successful
  def add_comment_to_issue_with_key issue_key, comment
    jira_call 'addComment', issue_key, comment
    true
  end

  # @param [String] id
  # @return [JIRA::Comment]
  def get_comment_with_id id
    JIRA::Comment.new_with_xml jira_call( 'getComment', id )
  end

  # @param [String] issue_key
  # @return [Array<JIRA::Comment>]
  def get_comments_for_issue_with_key issue_key
    array_jira_call JIRA::Comment, 'getComments', issue_key
  end

  # @param [JIRA::Comment] comment
  # @return [JIRA::Comment]
  def update_comment comment
    JIRA::Comment.new_with_xml jira_call( 'editComment', comment )
  end

  # @endgroup
end
end
