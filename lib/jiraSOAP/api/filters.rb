module JIRA
module RemoteAPI
  # @group Working with Filters

  # Retrieves favourite filters for the currently logged in user.
  # @return [[JIRA::Filter]]
  def get_favourite_filters
    jira_call( 'getFavouriteFilters' ).map { |frag|
      JIRA::Filter.new_with_xml frag
    }
  end
  alias_method :get_favorite_filters, :get_favourite_filters

  # @param [String] id
  # @return [Fixnum]
  def get_issue_count_for_filter_with_id id
    jira_call( 'getIssueCountForFilter', id ).to_i
  end

  # @endgroup
end
end
