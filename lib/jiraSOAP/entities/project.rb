# Contains the data and metadata about a project and its configuration.
class JIRA::Project < JIRA::DescribedEntity
  add_attributes(
    ['key',                 :key,                   :to_s],
    ['lead',                :lead_username,         :to_s],
    ['issueSecurityScheme', :issue_security_scheme, :to_object, JIRA::IssueSecurityScheme],
    ['notificationScheme',  :notification_scheme,   :to_object, JIRA::NotificationScheme],
    ['permissionScheme',    :permission_scheme,     :to_object, JIRA::PermissionScheme],
    ['url',                 :jira_url,              :to_url],
    ['projectUrl',          :project_url,           :to_url]
  )

  # @todo make this method shorter
  # @todo encode the schemes
  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for(msg)
    msg.add 'id', @id
    msg.add 'name', @name
    msg.add 'key', @key
    msg.add 'url', @jira_url
    msg.add 'projectUrl', @project_url
    msg.add 'lead', @lead_username
    msg.add 'description', @description
  end
end
