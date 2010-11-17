module JIRA

# Contains the data and metadata about a project and its configuration.
class Project < JIRA::DescribedEntity

  # @return [String]
  attr_accessor :key

  # @return [URL]
  attr_accessor :url

  # @return [URL]
  attr_accessor :project_url

  # @return [String]
  attr_accessor :lead

  # @return [JIRA::IssueSecurityScheme]
  attr_accessor :issue_security_scheme

  # @return [JIRA::NotificationScheme]
  attr_accessor :notification_scheme

  # @return [JIRA::PermissionScheme]
  attr_accessor :permission_scheme

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    super frag
    @key, @lead,
    @issue_security_scheme, @notification_scheme, @permission_scheme,
    @url, @project_url =
      frag.nodes( ['key',                 :to_s],
                  ['lead',                :to_s],
                  ['issueSecurityScheme', :to_object, JIRA::IssueSecurityScheme],
                  ['notificationScheme',  :to_object, JIRA::NotificationScheme],
                  ['permissionScheme',    :to_object, JIRA::PermissionScheme],
                  ['url',                 :to_url],
                  ['projectUrl',          :to_url] )
  end

  # @todo make this method shorter
  # @todo encode the schemes
  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for(msg)
    msg.add 'id', @id
    msg.add 'name', @name
    msg.add 'key', @key
    msg.add 'url', @url
    msg.add 'projectUrl', @project_url
    msg.add 'lead', @lead
    msg.add 'description', @description
  end
end

end
