module JIRA::RemoteAPI

  # @group Projects

  ##
  # You need to explicitly ask for schemes in order to get them. By
  # default, most project fetching methods purposely leave out all
  # the scheme information as permission schemes can be very large.
  #
  # @param [String] project_key
  # @return [JIRA::Project]
  def project_with_key project_key
    JIRA::Project.new_with_xml jira_call( 'getProjectByKey', project_key )
  end
  deprecate :project_with_key

  # @param [String] project_id
  # @return [JIRA::Project]
  def project_with_id project_id
    JIRA::Project.new_with_xml jira_call( 'getProjectById', project_id )
  end
  deprecate :project_with_id

  ##
  # @todo Parse the permission scheme
  # @note This method does not yet include the permission scheme.
  #
  # @param [String] project_id
  # @return [JIRA::Project]
  def project_including_schemes_with_id project_id
    JIRA::Project.new_with_xml jira_call( 'getProjectWithSchemesById', project_id )
  end
  deprecate :project_including_schemes_with_id

  ##
  # @note This will not fill in {JIRA::Scheme} data for the projects.
  #
  # @return [Array<JIRA::Project>]
  def projects
    array_jira_call JIRA::Project, 'getProjectsNoSchemes'
  end
  deprecate :projects

  ##
  # Requires you to set at least a project name, key, and lead.
  # However, it is also a good idea to set other project properties, such as
  # the permission scheme as the default permission scheme can be too
  # restrictive in most cases.
  #
  # @param [JIRA::Project] project
  # @return [JIRA::Project]
  def create_project_with_project project
    JIRA::Project.new_with_xml jira_call( 'createProjectFromObject', project )
  end

  ##
  # The id of the project is the only field that you cannot update. Or, at
  # least the only field I know that you cannot update.
  #
  # @param [JIRA::Project] project
  # @return [JIRA::Project]
  def update_project_with_project project
    JIRA::Project.new_with_xml jira_call( 'updateProject', project )
  end

  # @param [String] project_key
  # @return [Boolean] true if successful
  def delete_project_with_key project_key
    jira_call 'deleteProject', project_key
    true
  end

end
