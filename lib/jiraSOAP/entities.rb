require 'jiraSOAP/entities/abstract'
require 'jiraSOAP/entities/read_only'
require 'jiraSOAP/entities/field_value'
require 'jiraSOAP/entities/user'

require 'jiraSOAP/entities/avatar'
require 'jiraSOAP/entities/comment'
require 'jiraSOAP/entities/issue'

module JIRA

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
