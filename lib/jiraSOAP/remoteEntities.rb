module JIRA

# Represents a priority level. Straightforward.
class Priority
  attr_accessor :id, :name, :color, :icon, :description

  # Factory method that takes a fragment of a SOAP response.
  # @todo change @color to be some kind of hex Fixnum object
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Priority,nil]
  def self.priority_with_xml_fragment(frag)
    return if frag.nil?
    priority             = Priority.new
    priority.id          = frag.xpath('id').to_s
    priority.name        = frag.xpath('name').to_s
    priority.color       = frag.xpath('color').to_s
    priority.description = frag.xpath('description').to_s
    url                  = frag.xpath('icon').to_s
    priority.icon        = URL.new url unless url.nil?
    priority
  end
end

# Represents a resolution. Straightforward.
class Resolution
  attr_accessor :id, :name, :icon, :description

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Resolution,nil]
  def self.resolution_with_xml_fragment(frag)
    return if frag.nil?
    resolution             = Resolution.new
    resolution.id          = frag.xpath('id').to_s
    resolution.name        = frag.xpath('name').to_s
    resolution.description = frag.xpath('description').to_s
    url                    = frag.xpath('icon').to_s
    resolution.icon        = url unless url.nil?
    resolution
  end
end

# Represents a field mapping.
class Field
  attr_accessor :id, :name

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Field,nil]
  def self.field_with_xml_fragment(frag)
    return if frag.nil?
    field      = Field.new
    field.id   = frag.xpath('id').to_s
    field.name = frag.xpath('name').to_s
    field
  end
end

# Represents a custom field with values.
# @todo see if @key is always nil from the server
class CustomField
  attr_accessor :id, :key, :values

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::CustomField,nil]
  def self.custom_field_with_xml_fragment(frag)
    return if frag.nil?
    custom_field        = CustomField.new
    custom_field.id     = frag.xpath('customfieldId').to_s
    custom_field.key    = frag.xpath('key').to_s
    custom_field.values = frag.xpath('values/*').map { |value| value.to_s }
    custom_field
  end

  # Generate a SOAP message fragment for the object.
  # @param [Handsoap::XmlMason::Node] msg SOAP message to add the object to
  # @param [String] label tag name used in wrapping tags
  # @return [Handsoap::XmlMason::Element]
  def soapify_for(msg, label = 'customFieldValues')
    msg.add label do |submsg|
      submsg.add 'customfieldId', @id
      submsg.add 'key', @key
      submsg.add_simple_array 'values', @values
    end
  end
end

# Represents and issue type. Straight forward.
class IssueType
  attr_accessor :id, :name, :icon, :description
  attr_writer   :subtask

  # @return [boolean] true if the issue type is a subtask, otherwise false
  def subtask?; @subtask; end

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::IssueType,nil]
  def self.issue_type_with_xml_fragment(frag)
    return if frag.nil?
    issue_type             = IssueType.new
    issue_type.id          = frag.xpath('id').to_s
    issue_type.name        = frag.xpath('name').to_s
    issue_type.subtask     = frag.xpath('subTask').to_s == 'true'
    issue_type.description = frag.xpath('description').to_s
    url                    = frag.xpath('icon').to_s
    issue_type.icon        = URL.new url unless url.nil?
    issue_type
  end
end

# Represents a comment. Straight forward.
class Comment
  attr_accessor :id, :original_author, :role_level, :group_level, :body
  attr_accessor :create_date, :last_updated, :update_author

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Comment,nil]
  def self.comment_with_xml_fragment(frag)
    return if frag.nil?
    comment                 = Comment.new
    comment.id              = frag.xpath('id').to_s
    comment.original_author = frag.xpath('author').to_s
    comment.body            = frag.xpath('body').to_s
    comment.group_level     = frag.xpath('updateAuthor').to_s
    comment.role_level      = frag.xpath('roleLevel').to_s
    comment.update_author   = frag.xpath('updateAuthor').to_s
    date = frag.xpath('created').to_s
    comment.create_date     = Time.xmlschema date unless date.nil?
    date = frag.xpath('updated').to_s
    comment.last_updated    = Time.xmlschema date unless date.nil?
    comment
  end
end

# Represents a status. Straightforward.
class Status
  attr_accessor :id, :name, :icon, :description

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Status,nil]
  def self.status_with_xml_fragment(frag)
    return if frag.nil?
    status             = Status.new
    status.id          = frag.xpath('id').to_s
    status.name        = frag.xpath('name').to_s
    status.description = frag.xpath('description').to_s
    url                = frag.xpath('icon').to_s
    status.icon        = URL.new url unless url.nil?
    status
  end
end

# Represents a version for a project. The description field is never
# included when you retrieve versions from the server.
# @todo find out why we don't get a description for this object
class Version
  attr_accessor :id, :name, :sequence, :released, :archived, :release_date
  attr_writer   :released, :archived

  # @return [boolean] true if the version has been released, otherwise false
  def released?; @released; end

  # @return [boolean] true if the version has been archive, otherwise false
  def archived?; @archived; end

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Status,nil]
  def self.version_with_xml_fragment(frag)
    return if frag.nil?
    version              = Version.new
    version.id           = frag.xpath('id').to_s
    version.name         = frag.xpath('name').to_s
    version.sequence     = frag.xpath('sequence').to_s.to_i
    version.released     = frag.xpath('released').to_s == 'true'
    version.archived     = frag.xpath('archived').to_s == 'true'
    date = frag.xpath('releaseDate').to_s
    version.release_date = Time.xmlschema date unless date.nil?
    version
  end

  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for(msg)
    msg.add 'name', @name
    msg.add 'sequence', @sequence unless @sequence.nil?
    msg.add 'releaseDate', @release_date.xmlschema unless @release_date.nil?
    msg.add 'released', @released
  end
end

# Represents a scheme used by the server. Not very useful for the sake of the
# API; a more useful case might be if you wanted to emulate the server's
# behaviour.
class Scheme
  attr_accessor :id, :name, :type, :description

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Scheme,nil]
  def self.scheme_with_xml_fragment(frag)
    return if frag.nil?
    scheme             = Scheme.new
    scheme.id          = frag.xpath('id').to_s
    scheme.name        = frag.xpath('name').to_s
    scheme.type        = frag.xpath('type').to_s
    scheme.description = frag.xpath('description').to_s
    scheme
  end
end

# Represents a component description for a project. Straightforward.
class Component
  attr_accessor :id, :name

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Component,nil]
  def self.component_with_xml_fragment(frag)
    return if frag.nil?
    component      = Component.new
    component.id   = frag.xpath('id').to_s
    component.name = frag.xpath('name').to_s
    component
  end
end

# Represents a project configuration. NOT straightforward.
# @todo find out why the server always seems to pass nil for schemes
class Project
  attr_accessor :id, :name, :key, :url, :project_url, :lead, :description
  attr_accessor :issue_security_scheme, :notification_scheme, :permission_scheme

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Project,nil]
  def self.project_with_xml_fragment(frag)
    return if frag.nil?
    project = Project.new
    project.id                    = frag.xpath('id').to_s
    project.name                  = frag.xpath('name').to_s
    project.key                   = frag.xpath('key').to_s
    project.lead                  = frag.xpath('lead').to_s
    project.description           = frag.xpath('description').to_s
    project.issue_security_scheme =
      Scheme.scheme_with_xml_fragment frag.xpath 'issueSecurityScheme'
    project.notification_scheme   =
      Scheme.scheme_with_xml_fragment frag.xpath 'notificationScheme'
    project.permission_scheme     =
      Scheme.scheme_with_xml_fragment frag.xpath 'permissionScheme'
    url                           = frag.xpath('url').to_s
    project.url                   = URL.new url unless url.nil?
    url                           = frag.xpath('projectUrl').to_s
    project.project_url           = URL.new url unless url.nil?
    project
  end

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

# Contains a base64 encoded avatar image and some metadata. Straightforward.
class Avatar
  attr_accessor :id, :owner, :type, :content_type, :base64_data
  attr_writer   :system

  # @return [boolean] true if avatar is the default system avatar, else false
  def system?; @system; end

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Avatar,nil]
  def self.avatar_with_xml_fragment(frag)
    return if frag.nil?
    avatar              = Avatar.new
    avatar.id           = frag.xpath('id').to_s
    avatar.owner        = frag.xpath('owner').to_s
    avatar.system       = frag.xpath('system').to_s == 'true'
    avatar.type         = frag.xpath('type').to_s
    avatar.content_type = frag.xpath('contentType').to_s
    avatar.base64_data  = frag.xpath('base64Data').to_s
    avatar
  end
end

# Represents a JIRA issue; easily the most convoluted structure in the API.
# This structure and anything related directly to it will most likely be the
# greatest source of bugs.
#
# The irony of the situation is that this structure is also the most critical
# to have in working order.
#
# Issues with an UNRESOLVED status will have nil for the value of @resolution.
class Issue
  attr_accessor :id, :key, :summary, :description, :type_id, :last_updated
  attr_accessor :votes, :status_id, :assignee_name, :reporter_name, :priority_id
  attr_accessor :project_name, :affects_versions, :create_date, :due_date
  attr_accessor :fix_versions, :resolution_id, :environment, :components
  attr_accessor :attachment_names, :custom_field_values

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Issue,nil]
  def self.issue_with_xml_fragment(frag)
    return if frag.nil?
    issue                     = Issue.new
    issue.affects_versions    = frag.xpath('affectsVersions/*').map { |frag|
      Version.version_with_xml_fragment frag
    }
    issue.fix_versions        = frag.xpath('fixVersions/*').map { |frag|
      Version.version_with_xml_fragment frag
    }
    issue.components          = frag.xpath('components/*').map { |frag|
      Component.component_with_xml_fragment frag
    }
    issue.custom_field_values = frag.xpath('customFieldValues/*').map { |frag|
      CustomField.custom_field_with_xml_fragment frag
    }
    issue.attachment_names    = frag.xpath('attachmentNames/*').map { |name|
      name.to_s
    }
    issue.id                  = frag.xpath('id').to_s
    issue.key                 = frag.xpath('key').to_s
    issue.summary             = frag.xpath('summary').to_s
    issue.description         = frag.xpath('description').to_s
    issue.type_id             = frag.xpath('type').to_s
    issue.votes               = frag.xpath('votes').to_s.to_i
    issue.status_id           = frag.xpath('status').to_s
    issue.assignee_name       = frag.xpath('assignee').to_s
    issue.reporter_name       = frag.xpath('reporter').to_s
    issue.priority_id         = frag.xpath('priority').to_s
    issue.project_name        = frag.xpath('project').to_s
    issue.resolution_id       = frag.xpath('resolution').to_s
    issue.environment         = frag.xpath('environment').to_s
    date = frag.xpath('updated').to_s
    issue.last_updated        = Time.xmlschema date unless date.nil?
    date = frag.xpath('updated').to_s
    issue.create_date         = Time.xmlschema date unless date.nil?
    date = frag.xpath('updated').to_s
    issue.due_date            = Time.xmlschema date unless date.nil?
    issue
  end

  # Generate the SOAP message fragment for an issue. Can you spot the oddities
  # and inconsistencies? (hint: there are many).
  #
  # We don't bother including fields that are ignored. I tried to only
  # ignore fields that will never be needed at creation time, but I may have
  # messed up.
  #
  # We don't wrap the whole thing in 'issue' tags for
  # {#RemoteAPI#create_issue_with_issue} calls; this is an inconsistency in the
  # way jiraSOAP works and may need to be worked around for other {RemoteAPI}
  # methods.
  #
  # Servers only seem to accept issues if components/versions are just ids
  # and do not contain the rest of the {JIRA::Component}/{JIRA::Version}
  # structure.
  #
  # To get the automatic assignee we pass '-1' as the value for @assignee.
  #
  # Passing an environment/due date field with a value of nil causes the
  # server to complain about the formatting of the message.
  # @param [Handsoap::XmlMason::Node] msg  message the node to add the object to
  def soapify_for(msg)
    #might be going away, since it appears to have no effect at creation time
    msg.add 'reporter', @reporter_name unless @reporter.nil?

    msg.add 'priority', @priority_id
    msg.add 'type', @type_id
    msg.add 'project', @project_name

    msg.add 'summary', @summary
    msg.add 'description', @description

    msg.add 'components' do |submsg|
      (@components || []).each { |component|
        submsg.add 'components' do |component_msg|
          component_msg.add 'id', component.id
        end
      }
    end
    msg.add 'affectsVersions' do |submsg|
      (@affects_versions || []).each { |version|
        submsg.add 'affectsVersions' do |version_msg|
          version_msg.add 'id', version.id
        end
      }
    end
    msg.add 'fixVersions' do |submsg|
      (@fix_versions || []).each { |version|
        submsg.add 'fixVersions' do |version_msg|
          version_msg.add 'id', version.id end
      }
    end

    msg.add 'assignee', (@assignee_name || '-1')
    msg.add_complex_array 'customFieldValues', (@custom_field_values || [])

    msg.add 'environment', @environment unless @environment.nil?
    msg.add 'duedate', @due_date.xmlschema unless @due_date.nil?
  end
end

# Contains the basic information about a user. Straightforward.
class User
  attr_accessor :name, :full_name, :email

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::User,nil]
  def self.user_with_xml_fragment(frag)
    return if frag.nil?
    user           = User.new
    user.name      = frag.xpath('name').to_s
    user.full_name = frag.xpath('fullname').to_s
    user.email     = frag.xpath('email').to_s
    user
  end
end

# A structure that is a bit of a hack. It is essentially just a key-value pair
# that is used mainly by {RemoteAPI#update_issue}.
class FieldValue
  attr_accessor :id, :values

  # Factory method that gives you a nil value for the given id.
  # @param [String] id name of the field for @values
  # @return [JIRA::FieldValue] Will always have @values = [nil]
  def self.field_value_with_nil_values(id)
    fv = FieldValue.new
    fv.id = id
    fv.values = [nil]
    fv
  end

  # Generate the SOAP message fragment for a field value.
  # @param [Handsoap::XmlMason::Node] message the node to add the object to
  # @param [String] label name for the tags that wrap the message
  # @return [Handsoap::XmlMason::Element]
  def soapify_for(message, label = 'fieldValue')
    message.add label do |message|
      message.add 'id', @id
      message.add_simple_array 'values', @values
    end
  end
end

# Only contains the meta-data for an attachment. The URI for an attachment
# appears to be of the form
# $ENDPOINT_URL/secure/attachment/$ATTACHMENT_ID/$ATTACHMENT_FILENAME
class AttachmentMetadata
  attr_accessor :id, :author, :create_date, :filename, :file_size, :mime_type

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Attachment,nil]
  def self.attachment_with_xml_fragment(frag)
    return if frag.nil?
    attachment             = AttachmentMetadata.new
    attachment.id          = frag.xpath('id').to_s
    attachment.author      = frag.xpath('author').to_s
    attachment.filename    = frag.xpath('filename').to_s
    attachment.file_size   = frag.xpath('filesize').to_s.to_i
    attachment.mime_type   = frag.xpath('mimetype').to_s
    date = frag.xpath('created').to_s
    attachment.create_date = Time.xmlschema date unless date.nil?
    attachment
  end
end

# Only contains basic information about the endpoint server.
# @todo turn attributes back to read-only by not using a factory for init
class ServerInfo
  attr_accessor :base_url, :build_date, :build_number, :edition
  attr_accessor :server_time, :version

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::ServerInfo,nil]
  def self.server_info_with_xml_fragment(frag)
    return if frag.nil?
    server_info = ServerInfo.new
    server_info.build_number = frag.xpath('buildNumber').to_s.to_i
    server_info.edition      = frag.xpath('edition').to_s
    server_info.version      = frag.xpath('version').to_s
    date = frag.xpath('buildDate').to_s
    server_info.build_date   = Time.xmlschema date unless date.nil?
    server_info.server_time  =
      TimeInfo.time_info_with_xml_fragment frag.xpath 'serverTime'
    url                      = frag.xpath('baseUrl').to_s
    server_info.base_url     = URL.new url unless url.nil?
    server_info
  end
end

# Simple structure for a time and time zone; used oddly.
# The only place this structure is used is when #get_server_info is called.
# @todo turn attributes back to read-only by not using a factory for init
class TimeInfo
  attr_accessor :server_time, :timezone

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::TimeInfo,nil]
  def self.time_info_with_xml_fragment(frag)
    return if frag.nil?
    time_info             = TimeInfo.new
    time_info.server_time = Time.parse frag.xpath('serverTime').to_s
    time_info.timezone    = frag.xpath('timeZoneId').to_s
    time_info
  end
end

# Represents a filter
# @todo find out what @project is supposed to be for
class Filter
  attr_accessor :id, :name, :author, :project, :description, :xml

  # Factory method that takes a fragment of a SOAP response.
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Filter,nil]
  def self.filter_with_xml_fragment(frag)
    return if frag.nil?
    filter             = Filter.new
    filter.id          = frag.xpath('id').to_s
    filter.name        = frag.xpath('name').to_s
    filter.author      = frag.xpath('author').to_s
    filter.project     = frag.xpath('project').to_s
    filter.description = frag.xpath('description').to_s
    filter.xml         = frag.xpath('xml').to_s
    filter
  end
end

end
