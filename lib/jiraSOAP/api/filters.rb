module JIRA::RemoteAPI

  # @group Filters

  ##
  # Retrieves favourite filters for the currently logged in user.
  #
  # @return [Array<JIRA::Filter>]
  def favourite_filters
    array_jira_call JIRA::Filter, 'getFavouriteFilters'
  end
  alias_method :get_favourite_filters, :favourite_filters
  alias_method :get_favorite_filters,  :favourite_filters
  alias_method :favorite_filters,      :favourite_filters

  # @param [String] id
  # @return [Fixnum]
  def issue_count_for_filter_with_id id
    jira_call( 'getIssueCountForFilter', id ).to_i
  end
  alias_method :get_issue_count_for_filter_with_id, :issue_count_for_filter_with_id

end
