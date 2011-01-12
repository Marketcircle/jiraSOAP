module JIRA
module RemoteAPI
  # @group Working with Filters

  # Retrieves favourite filters for the currently logged in user.
  # @return [[JIRA::Filter]]
  def get_favourite_filters
    response = invoke('soap:getFavouriteFilters') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getFavouriteFiltersReturn").map {
      |frag| JIRA::Filter.new_with_xml frag
    }
  end
  alias_method :get_favorite_filters, :get_favourite_filters

  # @param [String] id
  # @return [Fixnum]
  def get_issue_count_for_filter_with_id id
    response = invoke('soap:getIssueCountForFilter') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', id
    }
    response.document.xpath('//getIssueCountForFilterReturn').to_i
  end

  # @endgroup
end
end
