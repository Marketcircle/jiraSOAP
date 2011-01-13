module JIRA
module RemoteAPI
  # @group Working with Project Roles

  # @return [Array<JIRA::ProjectRole>]
  def get_project_roles
    jira_call( 'getProjectRoles' ).map { |frag| JIRA::ProjectRole.new_with_xml frag }
  end

  # @param [String] role_id
  # @return [JIRA::ProjectRole]
  def get_project_role_with_id role_id

    JIRA::ProjectRole.new_with_xml jira_call( 'getProjectRole', role_id ).first
  end

  # @param [JIRA::ProjectRole] project_role
  # @return [JIRA::ProjectRole] the role that was created
  def create_project_role_with_role project_role
    response = invoke('soap:createProjectRole') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project_role.soapify_for submsg end
    }
    JIRA::ProjectRole.new_with_xml response.document.xpath('//createProjectRoleReturn').first
  end

  # @note JIRA 4.0 returns an exception if the name already exists
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
    invoke('soap:deleteProjectRole') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project_role.soapify_for submsg end
      msg.add 'soap:in2', confirm
    }
    true
  end

  # @note JIRA 4.0 will not update project roles, it will instead throw
  #  an exception telling you that the project role already exists
  # @param [JIRA::ProjectRole] project_role
  # @return [JIRA::ProjectRole] the role after the update
  def update_project_role_with_role project_role
    response = invoke('soap:updateProjectRole') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project_role.soapify_for submsg end
    }
    JIRA::ProjectRole.new_with_xml response.document.xpath('//updateProjectRoleReturn').first
  end

  # @endgroup
end
end
