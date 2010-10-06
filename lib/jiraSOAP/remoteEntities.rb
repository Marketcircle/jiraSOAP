module JIRA

# Represents a priority level. Straightforward.
class Priority
  attr_accessor :id, :name, :color, :icon, :description
  # Factory method that takes a fragment of a SOAP response.
  # @todo change @color to be some kind of hex Fixnum object
  # @todo change @icon to be a URI or NSURL object
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  # @return [JIRA::Priority,nil]
  def self.priority_with_xml_fragment(frag)
    return if frag.nil?
    priority             = Priority.new
    priority.id          = frag.xpath('id').to_s
    priority.name        = frag.xpath('name').to_s
    priority.color       = frag.xpath('color').to_s
    priority.icon        = frag.xpath('icon').to_s
    priority.description = frag.xpath('description').to_s
    priority
  end
end

# Represents a priority level. Straightforward.
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
    resolution.icon        = frag.xpath('icon').to_s #FIXME: NSURL
    resolution.description = frag.xpath('description').to_s
    resolution
  end
end

class Field
  attr_accessor :id, :name
  def self.field_with_xml_fragment(frag)
    return if frag.nil?
    field      = Field.new
    field.id   = frag.xpath('id').to_s
    field.name = frag.xpath('name').to_s
    field
  end
end

class CustomField
  attr_accessor :id, :key, :values
  def self.custom_field_with_xml_fragment(frag)
    return if frag.nil?
    custom_field        = CustomField.new
    custom_field.id     = frag.xpath('customfieldId').to_s
    custom_field.key    = frag.xpath('key').to_s
    custom_field.values = frag.xpath('values/*').map { |value| value.to_s }
    custom_field
  end
  def soapify_for(msg, label = 'customFieldValues')
    msg.add label do |submsg|
      submsg.add 'customfieldId', @id
      submsg.add 'key', @key #TODO: see if this is always nil
      submsg.add_simple_array 'values', @values
    end
  end
end

class IssueType
  attr_accessor :id, :name, :icon, :description
  attr_writer   :subtask
  def subtask?; @subtask; end
  def self.issue_type_with_xml_fragment(frag)
    return if frag.nil?
    issue_type             = IssueType.new
    issue_type.id          = frag.xpath('id').to_s
    issue_type.name        = frag.xpath('name').to_s
    issue_type.icon        = frag.xpath('icon').to_s #FIXME: NSURL
    issue_type.subtask     = frag.xpath('subtask').to_s == 'true'
    issue_type.description = frag.xpath('description').to_s
    issue_type
  end
end

class Status
  attr_accessor :id, :name, :icon, :description
  def self.status_with_xml_fragment(frag)
    return if frag.nil?
    status             = Status.new
    status.id          = frag.xpath('id').to_s
    status.name        = frag.xpath('name').to_s
    status.icon        = frag.xpath('icon').to_s #FIXME: NSURL
    status.description = frag.xpath('description').to_s
    status
  end
end

class Version
  attr_accessor :id, :name, :sequence, :released, :archived, :release_date
  attr_writer   :released, :archived
  def released?; @released; end
  def archived?; @archived; end
  def self.version_with_xml_fragment(frag)
    return if frag.nil?
    #TODO: find out why we don't get a description for this type
    version              = Version.new
    version.id           = frag.xpath('id').to_s
    version.name         = frag.xpath('name').to_s
    version.sequence     = frag.xpath('sequence').to_s.to_i
    version.released     = frag.xpath('released').to_s == 'true'
    version.archived     = frag.xpath('archived').to_s == 'true'
    version.release_date = frag.xpath('releaseDate') #FIXME: Time.rfc2822
    version
  end
end

class Scheme
  attr_accessor :id, :name, :type, :description
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

class Component
  attr_accessor :id, :name
  def self.component_with_xml_fragment(frag)
    return if frag.nil?
    component      = Component.new
    component.id   = frag.xpath('id').to_s
    component.name = frag.xpath('name').to_s
    component
  end
end

class Project
  attr_accessor :id, :name, :key, :url, :project_url, :lead, :description
  attr_accessor :issue_security_scheme, :notification_scheme, :permission_scheme
  def self.project_with_xml_fragment(frag)
    return if frag.nil?
    project = Project.new
    project.id                    = frag.xpath('id').to_s
    project.name                  = frag.xpath('name').to_s
    project.key                   = frag.xpath('key').to_s
    project.url                   = frag.xpath('url').to_s #FIXME: NSURL
    project.project_url           = frag.xpath('projectUrl').to_s #FIXME: NSURL
    project.lead                  = frag.xpath('lead').to_s
    project.description           = frag.xpath('description').to_s
    #TODO: find out why the server always seems to pass nil
    project.issue_security_scheme =
      Scheme.scheme_with_xml_fragment frag.xpath 'issueSecurityScheme'
    project.notification_scheme   =
      Scheme.scheme_with_xml_fragment frag.xpath 'notificationScheme'
    project.permission_scheme     =
      Scheme.scheme_with_xml_fragment frag.xpath 'permissionScheme'
    project
  end
end

class Avatar
  attr_accessor :id, :owner, :type, :content_type, :base64_data
  attr_writer   :system
  def system?; @system; end
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

#easily the most convoluted structure in the API
#will most likely be the greatest source of bugs
class Issue
  attr_accessor :id, :key, :summary, :description, :type_id, :last_updated
  attr_accessor :votes, :status_id, :assignee_name, :reporter_name, :priority_id
  attr_accessor :project_name, :affects_versions, :create_date, :due_date
  attr_accessor :fix_versions, :resolution_id, :environment, :components
  attr_accessor :attachment_names, :custom_field_values
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
    issue.last_updated        = frag.xpath('updated').to_s
    issue.votes               = frag.xpath('votes').to_s.to_i
    issue.status_id           = frag.xpath('status').to_s
    issue.assignee_name       = frag.xpath('assignee').to_s
    issue.reporter_name       = frag.xpath('reporter').to_s
    issue.priority_id         = frag.xpath('priority').to_s
    issue.project_name        = frag.xpath('project').to_s
    issue.create_date         = frag.xpath('created').to_s #FIXME: Time.rfc2822
    issue.due_date            = frag.xpath('duedate').to_s #FIXME: Time.rfc2822
    issue.resolution_id       = frag.xpath('resolution').to_s
    issue.environment         = frag.xpath('environment').to_s
    issue
  end
  #can you spot the oddities and inconsistencies? (hint: there are many)
  def soapify_for(msg)
    #we don't both including fields that are ignored
      #I tried to only ignore fields that will never be needed at creation
      #but I may have messed up. It should be easy to fix :)
    #we don't wrap the whole thing in 'issue' tags for #create_issue calls
      #this is an inconsistency in the way jiraSOAP works
      #but you'll probably never know unless you read the source

    #might be going away, since it appears to have no effect at creation time
    msg.add 'reporter', @reporter_name unless @reporter.nil?

    msg.add 'priority', @priority_id
    msg.add 'type', @type_id
    msg.add 'project', @project_name

    msg.add 'summary', @summary
    msg.add 'description', @description

    #server only accepts issues if components/versions are just ids
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

    #-1 is the value you send to get the automatic assignee
    msg.add 'assignee', (@assignee_name || '-1')

    msg.add_complex_array 'customFieldValues', (@custom_field_values || [])

    #passing environment/due_date when nil seems to mess up the server
    msg.add 'environment', @environment unless @environment.nil?
    msg.add 'duedate', @due_date unless @due_date.nil?
  end
end

class User
  attr_accessor :name, :full_name, :email
  def self.user_with_xml_fragment(frag)
    return if frag.nil?
    user           = User.new
    user.name      = frag.xpath('name').to_s
    user.full_name = frag.xpath('fullname').to_s
    user.email     = frag.xpath('email').to_s
    user
  end
end

class FieldValue
  attr_accessor :id, :values
  def self.field_value_with_nil_values(id)
    fv = FieldValue.new
    fv.id = id
    fv.values = [nil]
    fv
  end
  def soapify_for(message, label = 'fieldValue')
    message.add label do |message|
      message.add 'id', @id
      message.add_simple_array 'values', @values
    end
  end
end

end
