module JIRA
module RemoteAPI

##
# @todo documentatiton
module ProjectRoles

  # @return [Array<JIRA::ProjectRole>]
  def get_project_roles
    array_jira_call JIRA::ProjectRole, 'getProjectRoles'
  end

  # @param [String] role_id
  # @return [JIRA::ProjectRole]
  def get_project_role_with_id role_id
    JIRA::ProjectRole.new_with_xml jira_call( 'getProjectRole', role_id )
  end

  # @param [JIRA::ProjectRole] project_role
  # @return [JIRA::ProjectRole] the role that was created
  def create_project_role_with_role project_role
    JIRA::ProjectRole.new_with_xml jira_call( 'createProjectRole', project_role )
  end

  # @note JIRA 4.0 and 4.2 returns an exception if the name already exists
  # Returns true if the name does not exist.
  # @param [String] project_role_name
  # @return [Boolean] true if successful
  def project_role_name_unique? project_role_name
    jira_call( 'isProjectRoleNameUnique', project_role_name ).to_boolean
  end

  # @note the confirm argument appears to do nothing (at least on JIRA 4.0)
  # @param [JIRA::ProjectRole] project_role
  # @param [Boolean] confirm
  # @return [Boolean] true if successful
  def delete_project_role project_role, confirm = true
    jira_call 'deleteProjectRole', project_role, confirm
    true
  end

  # @note JIRA 4.0 will not update project roles, it will instead throw
  #  an exception telling you that the project role already exists
  # @param [JIRA::ProjectRole] project_role
  # @return [JIRA::ProjectRole] the role after the update
  def update_project_role_with_role project_role
    JIRA::ProjectRole.new_with_xml jira_call( 'updateProjectRole', project_role )
  end

end
end
end
