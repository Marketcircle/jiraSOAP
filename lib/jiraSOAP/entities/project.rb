##
# Contains the data and metadata about a project and its configuration.
class JIRA::Project < JIRA::DescribedEntity

  # @return [String]
  add_attribute :key, 'key', :content

  # @return [String]
  add_attribute :lead_username, 'lead', :content

  # @return [String]
  add_attribute :issue_security_scheme, 'issueSecurityScheme', [:children_as_object, JIRA::IssueSecurityScheme]

  # @return [String]
  add_attribute :notification_scheme, 'notificationScheme', [:children_as_object, JIRA::NotificationScheme]

  # @return [String]
  add_attribute :permission_scheme, 'permissionScheme', [:children_as_object, JIRA::PermissionScheme]

  # @return [NSURL,URI::HTTP]
  add_attribute :jira_url, 'url', :to_url

  # @return [NSURL,URI::HTTP]
  add_attribute :project_url, 'projectUrl', :to_url


  ##
  # @todo Encode the schemes
  #
  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for msg
    msg.add 'id', @id
    msg.add 'name', @name
    msg.add 'key', @key
    msg.add 'url', @jira_url
    msg.add 'projectUrl', @project_url
    msg.add 'lead', @lead_username
    msg.add 'description', @description
  end

end
