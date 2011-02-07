module JIRA
module RemoteAPI
  # @group Working with Comments

  # @param [String] issue_key
  # @param [JIRA::Comment] comment
  # @return [Boolean] true if successful
  def add_comment_to_issue_with_key issue_key, comment
    call 'addComment', issue_key, comment
    true
  end

  # @param [String] id
  # @return [JIRA::Comment]
  def get_comment_with_id id
    JIRA::Comment.new_with_xml call( 'getComment', id ).first
  end

  # @param [String] issue_key
  # @return [Array<JIRA::Comment>]
  def get_comments_for_issue_with_key issue_key
    jira_call JIRA::Comment, 'getComments', issue_key
  end

  # @param [JIRA::Comment] comment
  # @return [JIRA::Comment]
  def update_comment comment
    JIRA::Comment.new_with_xml call( 'editComment', comment ).first
  end

  # @endgroup
end
end
