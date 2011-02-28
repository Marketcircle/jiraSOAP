module JIRA
module RemoteAPI

##
# @note {Issues#get_issues_from_filter_with_id} is implemented in
# {JIRA::RemoteAPI::Issues}.
module Filters

  ##
  # Retrieves favourite filters for the currently logged in user.
  #
  # @return [Array<JIRA::Filter>]
  def get_favourite_filters
    array_jira_call JIRA::Filter, 'getFavouriteFilters'
  end
  alias_method :get_favorite_filters, :get_favourite_filters

  ##
  # @param [String] id
  # @return [Fixnum]
  def get_issue_count_for_filter_with_id id
    jira_call( 'getIssueCountForFilter', id ).to_i
  end

end
end
end
