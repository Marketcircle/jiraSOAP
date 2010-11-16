require 'lib/jiraSOAP/entities/abstract'
require 'lib/jiraSOAP/entities/read_only'
require 'lib/jiraSOAP/entities/field_value'
require 'lib/jiraSOAP/entities/user'

require 'lib/jiraSOAP/entities/avatar'
require 'lib/jiraSOAP/entities/comment'

module JIRA

# Contains most of the data and metadata for a JIRA issue, but does
# not contain the {JIRA::Comment}'s or {JIRA::AttachmentMetadata}.
#
# This class is easily the most convoluted structure in the API, and will
# likely be the greatest source of bugs. The irony of the situation is that
# this structure is also the most critical to have in working order.
#
# Issues with an UNRESOLVED status will have nil for the value of @resolution.
class Issue < JIRA::DynamicEntity
  # @return [String]
  attr_accessor :key
  # @return [String]
  attr_accessor :summary
  # @return [String]
  attr_accessor :description
  # @return [String]
  attr_accessor :type_id
  # @return [Time]
  attr_accessor :last_updated
  # @return [Fixnum]
  attr_accessor :votes
  # @return [String]
  attr_accessor :status_id
  # @return [String]
  attr_accessor :assignee_name
  # @return [String]
  attr_accessor :reporter_name
  # @return [String]
  attr_accessor :priority_id
  # @return [String]
  attr_accessor :project_name
  # @return [[JIRA::Version]]
  attr_accessor :affects_versions
  # @return [Time]
  attr_accessor :create_date
  # @return [Time]
  attr_accessor :due_date
  # @return [[JIRA::Version]]
  attr_accessor :fix_versions
  # @return [String]
  attr_accessor :resolution_id
  # @return [String]
  attr_accessor :environment
  # @return [[JIRA::Component]]
  attr_accessor :components
  # @return [[String]]
  attr_accessor :attachment_names
  # @return [[JIRA::CustomFieldValue]]
  attr_accessor :custom_field_values

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    @id, @key, @summary, @description, @type_id, @status_id,
    @assignee_name, @reporter_name, @priority_id, @project_name,
    @resolution_id, @environment, @votes, @last_updated, @create_date,
    @due_date, @affects_versions, @fix_versions, @components,
    @custom_field_values, @attachment_names =
      frag.nodes( ['id',                  :to_s],
                  ['key',                 :to_s],
                  ['summary',             :to_s],
                  ['description',         :to_s],
                  ['type',                :to_s],
                  ['status',              :to_s],
                  ['assignee',            :to_s],
                  ['reporter',            :to_s],
                  ['priority',            :to_s],
                  ['project',             :to_s],
                  ['resolution',          :to_s],
                  ['environment',         :to_s],
                  ['votes',               :to_i],
                  ['updated',             :to_date],
                  ['created',             :to_date],
                  ['duedate',             :to_date],
                  ['affectsVersions/*',   :to_objects, JIRA::Version],
                  ['fixVersions/*',       :to_objects, JIRA::Version],
                  ['components/*',        :to_objects, JIRA::Component],
                  ['customFieldValues/*', :to_objects, JIRA::CustomFieldValue],
                  ['attachmentNames/*',   :to_ss] )
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
  # @todo see if we can use the simple and complex array builders
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

############################
# @pragma mark < NamedEntity
############################

# Represents a field mapping.
class Field < JIRA::NamedEntity
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    super frag unless frag
  end
end

# Represents a version for a project. The description field is never
# included when you retrieve versions from the server.
# @todo find out why we don't get a description for this object
class Version < JIRA::NamedEntity
  # @return [Fixnum]
  attr_accessor :sequence
  # @return [boolean]
  attr_accessor :released
  # @return [boolean]
  attr_accessor :archived
  # @return [Time]
  attr_accessor :release_date

  def released?; @released; end
  def archived?; @archived; end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    @id, @name, @sequence, @released, @archived, @release_date =
      frag.nodes( ['id',          :to_s],
                  ['name',        :to_s],
                  ['sequence',    :to_i],
                  ['released',    :to_boolean],
                  ['archived',    :to_boolean],
                  ['releaseDate', :to_date] )
  end

  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for(msg)
    msg.add 'name', @name
    msg.add 'archived', @archived unless @archived.nil?
    msg.add 'sequence', @sequence unless @sequence.nil?
    msg.add 'releaseDate', @release_date.xmlschema unless @release_date.nil?
    msg.add 'released', @released unless @released.nil?
  end
end

# Represents a component description for a project. It does not include
# the component lead.
class Component < JIRA::NamedEntity
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    super frag unless frag.nil?
  end
end

# Only contains the metadata for an attachment. The URI for an attachment
# appears to be of the form
# "{JIRA::JIRAService.uri}/secure/attachment/{#id}/{#filename}"
class AttachmentMetadata < JIRA::NamedEntity
  # @return [String]
  attr_accessor :author
  # @return [Time]
  attr_accessor :create_date
  # @return [String]
  attr_accessor :filename
  # @return [Fixnum] measured in bytes
  attr_accessor :file_size
  # @return [String]
  attr_accessor :mime_type

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    @id, @name, @author, @filename, @mime_type, @file_size, @create_date =
      frag.nodes( ['id',       :to_s],
                  ['name',     :to_s],
                  ['author',   :to_s],
                  ['filename', :to_s],
                  ['mimetype', :to_s],
                  ['filesize', :to_i],
                  ['created',  :to_date] )
  end
end

################################
# @pragma mark < DescribedEntity
################################

# Represents a filter, but does not seem to include the filters JQL query.
# @todo find out what @project is supposed to be for
class Filter < JIRA::DescribedEntity
  # @return [String]
  attr_accessor :author
  # @return [String]
  attr_accessor :project
  # @return [nil]
  attr_accessor :xml

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    @id, @name, @description, @author, @project, @xml =
      frag.nodes( ['id',          :to_s],
                  ['name',        :to_s],
                  ['description', :to_s],
                  ['author',      :to_s],
                  ['project',     :to_s],
                  ['xml',         :to_s] )
  end
end

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
  def initialize(frag = nil)
    return unless frag
    @id, @name, @description, @key, @lead,
    @issue_security_scheme, @notification_scheme, @permission_scheme,
    @url, @project_url =
      frag.nodes( ['id',                  :to_s],
                  ['name',                :to_s],
                  ['description',         :to_s],
                  ['key',                 :to_s],
                  ['lead',                :to_s],
                  ['issueSecurityScheme', :to_object, JIRA::IssueSecurityScheme],
                  ['notificationScheme',  :to_object, JIRA::NotificationScheme],
                  ['permissionScheme',    :to_object, JIRA::PermissionScheme],
                  ['url',                 :to_url],
                  ['projectUrl',          :to_url] )
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

##################################
# @pragma mark Inherit from Scheme
##################################

# @todo complete this class
# Includes a mapping of project specific permission settings.
class PermissionScheme < JIRA::Scheme
  # @return [nil]
  attr_accessor :permission_mappings

  # @todo actually parse the permission mapping
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    super frag unless frag
  end
end

# The basic metadata about a project's notification scheme.
class NotificationScheme < JIRA::Scheme
end

# The basic metadata about a project's issue security scheme.
class IssueSecurityScheme < JIRA::Scheme
end

#########################################
# @pragma mark Inherit from IssueProperty
#########################################

# Contains all the metadata for a resolution.
class Resolution < JIRA::IssueProperty
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    super frag unless frag
  end
end

# Contains all the metadata for an issue's status.
class Status < JIRA::IssueProperty
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    super frag unless frag
  end
end

# Contains all the metadata for a priority level.
# @todo change @color to be some kind of hex Fixnum object
class Priority < JIRA::IssueProperty
  # @return [String] is a hex value
  attr_accessor :color

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    super frag
    @color = (frag/'color').to_s
  end
end

# Contains all the metadata for an issue type.
class IssueType < JIRA::IssueProperty
  # @return [boolean]
  attr_accessor :subtask

  # @return [boolean] true if the issue type is a subtask, otherwise false
  def subtask?; @subtask; end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    super frag
    @subtask = (frag/'subTask').to_boolean
  end
end

end
