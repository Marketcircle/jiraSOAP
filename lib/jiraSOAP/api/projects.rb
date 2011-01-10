module JIRA
module RemoteAPI
  # @group Working with Projects

  # You need to explicitly ask for schemes in order to get them. By
  # default, most project fetching methods purposely leave out all
  # the scheme information as permission schemes can be very large.
  # @param [String] project_key
  # @return [JIRA::Project]
  def get_project_with_key project_key
    response = invoke('soap:getProjectByKey') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    JIRA::Project.new_with_xml response.document.xpath('//getProjectByKeyReturn').first
  end

  # Requires you to set at least a project name, key, and lead.
  # However, it is also a good idea to set other project properties, such as
  # the permission scheme as the default permission scheme can be too
  # restrictive in most cases.
  # @param [JIRA::Project] project
  # @return [JIRA::Project]
  def create_project_with_project project
    response = invoke('soap:createProjectFromObject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project.soapify_for submsg end
    }
    JIRA::Project.new_with_xml response.document.xpath('//createProjectFromObjectReturn').first
  end

  # The id of the project is the only field that you cannot update. Or, at
  # least the only field I know that you cannot update.
  # @param [JIRA::Project] project
  # @return [JIRA::Project]
  def update_project_with_project project
    response = invoke('soap:updateProject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1' do |submsg| project.soapify_for submsg end
    }
    JIRA::Project.new_with_xml response.document.xpath('//updateProjectReturn').first
  end

  # @param [String] project_id
  # @return [JIRA::Project]
  def get_project_with_id project_id
    response = invoke('soap:getProjectById') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_id
    }
    JIRA::Project.new_with_xml response.document.xpath('//getProjectByIdReturn').first
  end

  # @todo parse the permission scheme
  # Note: this method does not yet include the permission scheme.
  # @param [String] project_id
  # @return [JIRA::Project]
  def get_project_including_schemes_with_id project_id
    response = invoke('soap:getProjectWithSchemesById') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_id
    }
    JIRA::Project.new_with_xml response.document.xpath('//getProjectWithSchemesByIdReturn').first
  end

  # @param [String] project_name
  # @return [[JIRA::IssueType]]
  def get_issue_types_for_project_with_id(project_id)
    response = invoke('soap:getIssueTypesForProject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_id
    }
    response.document.xpath("#{RESPONSE_XPATH}/getIssueTypesForProjectReturn").map {
      |frag| JIRA::IssueType.new_with_xml frag
    }
  end

  # @note This will not fill in JIRA::Scheme data for the projects.
  # @return [[JIRA::Project]]
  def get_projects_without_schemes
    response = invoke('soap:getProjectsNoSchemes') { |msg|
      msg.add 'soap:in0', @auth_token
    }
    response.document.xpath("#{RESPONSE_XPATH}/getProjectsNoSchemesReturn").map {
      |frag| JIRA::Project.new_with_xml frag
    }
  end

  # @param [String] project_key
  # @return [true]
  def delete_project_with_key project_key
    invoke('soap:deleteProject') { |msg|
      msg.add 'soap:in0', @auth_token
      msg.add 'soap:in1', project_key
    }
    true
  end

  # @endgroup
end
end
