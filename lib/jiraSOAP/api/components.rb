module JIRA::RemoteAPI
  # @group Components

  ##
  # Lists a project's components
  #
  # @param [String] project_key
  # @return [Array<JIRA::Component>]

  def components_for_project_with_key project_key
    array_jira_call JIRA::Component, 'getComponents', project_key
  end

end
