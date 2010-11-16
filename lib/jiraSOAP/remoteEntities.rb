module JIRA

#######################
# @pragma mark < Object
#######################

# @abstract
class DynamicEntity
  # @return [String] usually holds a numerical value but for consistency with
  #  with id's from custom fields this attribute is always a String
  attr_accessor :id
end

# A structure that is a bit of a hack. It is essentially just a key-value pair
# that is used mainly by {RemoteAPI#update_issue}.
class FieldValue
  # @return [String]
  attr_accessor :field_name
  # @return [[String,Time,URL,JIRA::*,nil]] hard to say what the type should be
  attr_accessor :values

  # @param [String] field_name
  # @param [Array] values
  def initialize(field_name = nil, values = nil)
    @field_name = field_name
    @values     = values
  end

  # Generate the SOAP message fragment for a field value.
  # @param [Handsoap::XmlMason::Node] message the node to add the object to
  # @param [String] label name for the tags that wrap the message
  # @return [Handsoap::XmlMason::Element]
  def soapify_for(message, label = 'fieldValue')
    message.add label do |message|
      message.add 'id', @field_name
      message.add_simple_array 'values', @values unless @values.nil?
    end
  end
end

# Contains the basic information about a user. The only things missing here
# are the permissions and login statistics.
class User
  # @return [String]
  attr_accessor :username
  # @return [String]
  attr_accessor :full_name
  # @return [String]
  attr_accessor :email_address

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    @username, @full_name, @email_address =
      frag.nodes ['name', :to_s], ['fullname', :to_s], ['email', :to_s]
  end
end

# Only contains basic information about the endpoint server and only used
# by {RemoteAPI#get_server_info}.
class ServerInfo
  # @return [URL]
  attr_reader :base_url
  # @return [Time]
  attr_reader :build_date
  # @return [Fixnum]
  attr_reader :build_number
  # @return [String]
  attr_reader :edition
  # @return [JIRA::TimeInfo]
  attr_reader :server_time
  # @return [String]
  attr_reader :version

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @build_date, @build_number, @base_url, @edition, @version, @server_time =
      frag.nodes( ['buildDate',   :to_date],
                  ['buildNumber', :to_i],
                  ['baseUrl',     :to_url],
                  ['edition',     :to_s],
                  ['version',     :to_s],
                  ['serverTime',  :to_object, JIRA::TimeInfo] )
  end
end

# Simple structure for a time and time zone; only used by JIRA::ServerInfo
# objects, which themselves are only created when {RemoteAPI#get_server_info}
# is called.
class TimeInfo
  # @return [Time]
  attr_reader :server_time
  # @return [String] in the form of 'America/Toronto'
  attr_reader :timezone

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @server_time, @timezone =
      frag.nodes ['serverTime', :to_date], ['timeZoneId', :to_s]
  end
end

# A simple structure that is used by {RemoteAPI#get_server_configuration}.
class ServerConfiguration
  # @return [boolean]
  attr_reader :attachments_allowed
  # @return [boolean]
  attr_reader :external_user_management_allowed
  # @return [boolean]
  attr_reader :issue_linking_allowed
  # @return [boolean]
  attr_reader :subtasks_allowed
  # @return [boolean]
  attr_reader :time_tracking_allowed
  # @return [boolean]
  attr_reader :unassigned_issues_allowed
  # @return [boolean]
  attr_reader :voting_allowed
  # @return [boolean]
  attr_reader :watching_allowed
  # @return [Fixnum]
  attr_reader :time_tracking_days_per_week
  # @return [Fixnum]
  attr_reader :time_tracking_hours_per_day

  def attachments_allowed?; @attachments_allowed; end
  def external_user_management_allowed?; @external_user_management_allowed; end
  def issue_linking_allowed?; @issue_linking_allowed; end
  def subtasks_allowed?; @subtasks_allowed; end
  def time_tracking_allowed?; @time_tracking_allowed; end
  def unassigned_issues_allowed?; @unassigned_issues_allowed; end
  def voting_allowed?; @voting_allowed; end
  def watching_allowed?; @watching_allowed; end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @external_user_management_allowed, @attachments_allowed,
    @issue_linking_allowed,            @subtasks_allowed,
    @time_tracking_allowed,            @unassigned_issues_allowed,
    @voting_allowed,                   @watching_allowed,
    @time_tracking_days_per_week,      @time_tracking_hours_per_day =
      frag.nodes( ['allowExternalUserManagement', :to_boolean],
                  ['allowAttachments',            :to_boolean],
                  ['allowIssueLinking',           :to_boolean],
                  ['allowSubTasks',               :to_boolean],
                  ['allowTimeTracking',           :to_boolean],
                  ['allowUnassignedIssues',       :to_boolean],
                  ['allowVoting',                 :to_boolean],
                  ['allowWatching',               :to_boolean],
                  ['timeTrackingDaysPerWeek',     :to_i],
                  ['timeTrackingHoursPerDay',     :to_i] )
  end
end

##############################
# @pragma mark < DynamicEntity
##############################

# @abstract
class NamedEntity < JIRA::DynamicEntity
  # @return [String] a plain language name
  attr_accessor :name

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @id, @name = frag.nodes ['id', :to_s], ['name', :to_s]
  end
end

# Represents an instance of a custom field (with values). This object is used
# primarily as a member of {JIRA::Issue} objects.
#
# The structure of this class resembles JIRA::FieldValue, it is different
# in that @values will always be stored as an Array of String objects in a
# custom field and a field value is more flexible. You can expect the classes
# to merge in the near future.
# @todo see if @key is always nil from the server
# @todo merge this class with JIRA::FieldValue
class CustomFieldValue < JIRA::DynamicEntity
  # @return [String]
  attr_accessor :key
  # @return [[String]]
  attr_accessor :values

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    # careful, value of id is actually customfieldId
    @id, @key, @values =
      frag.nodes ['customfieldId', :to_s], ['key', :to_s], ['values/*', :to_ss]
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

# Contains a base64 encoded avatar image and metadata about the avatar.
class Avatar < JIRA::DynamicEntity
  # @return [String]
  attr_accessor :owner
  # @return [String] the place where the avatar is used
  attr_accessor :type
  # @return [String]
  attr_accessor :mime_type
  # @return [String]
  attr_accessor :base64_data
  # @return [boolean] indicates if the image is the system default
  attr_accessor :system

  # @return [boolean] true if avatar is the default system avatar, else false
  def system?; @system; end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    @id, @owner, @type, @mime_type, @base64_data, @system =
      frag.nodes( ['id',          :to_s],
                  ['owner',       :to_s],
                  ['type',        :to_s],
                  ['contentType', :to_s],
                  ['base64Data',  :to_s],
                  ['system',      :to_boolean] )
  end
end

# Contains a comments body and its metadata.
class Comment < JIRA::DynamicEntity
  # @return [String]
  attr_accessor :original_author
  # @return [String]
  attr_accessor :role_level
  # @return [String]
  attr_accessor :group_level
  # @return [String]
  attr_accessor :body
  # @return [Time]
  attr_accessor :create_date
  # @return [Time]
  attr_accessor :last_updated
  # @return [String]
  attr_accessor :update_author

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return unless frag
    @id, @original_author, @body, @group_level, @role_level, @update_author, @create_date, @last_updated =
      frag.nodes( ['id',           :to_s],
                  ['author',       :to_s],
                  ['body',         :to_s],
                  ['groupLevel',   :to_s],
                  ['roleLevel',    :to_s],
                  ['updateAuthor', :to_s],
                  ['created',      :to_date],
                  ['updated',      :to_date] )
  end

  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for(msg)
    msg.add 'id', @id
    msg.add 'author', @original_author
    msg.add 'body', @body
    msg.add 'groupLevel', @group_level
    msg.add 'roleLevel', @role_level
    msg.add 'updateAuthor', @update_author
  end
end

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

# @abstract
class DescribedEntity < JIRA::NamedEntity
  # @return [String] usually a short blurb
  attr_accessor :description

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @id, @name, @description =
      frag.nodes ['id', :to_s], ['name', :to_s], ['description', :to_s]
  end
end

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
# "{JIRA::JIRAService.endpoint_url}/secure/attachment/{#id}/{#filename}"
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

# Represents a scheme used by the server. Not very useful for the sake of the
# API; a more useful case might be if you wanted to emulate the server's
# behaviour.
# @abstract
class Scheme < JIRA::DescribedEntity
  # @return [String]
  def type
    self.class.to_s
  end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    super frag unless frag.nil?
  end
end

# @abstract
class IssueProperty < JIRA::DescribedEntity
  # @return [URL] A NSURL on MacRuby and a URI::HTTP object in CRuby
  attr_accessor :icon

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @id, @name, @description, @icon =
      frag.nodes( ['id',          :to_s],
                  ['name',        :to_s],
                  ['description', :to_s],
                  ['icon',        :to_url] )
  end
end

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
