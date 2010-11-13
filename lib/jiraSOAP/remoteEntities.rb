module JIRA

#######################
# @pragma mark < Object
#######################

# @abstract
class DynamicEntity
  # @return [String] usually holds a numerical value but for consistency with
  #  with id's from custom fields this attribute is always a String
  attr_accessor :id

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @id = frag.xpath('id').to_s
  end
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
    return if frag.nil?
    @username      = frag.xpath('name').to_s
    @full_name     = frag.xpath('fullname').to_s
    @email_address = frag.xpath('email').to_s
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
    url = nil
    date = nil
    @build_number = frag.xpath('buildNumber').to_s.to_i
    @edition      = frag.xpath('edition').to_s
    @version      = frag.xpath('version').to_s
    @build_date   = Time.xmlschema date unless (date = frag.xpath('buildDate').to_s).nil?
    @server_time  = TimeInfo.new frag.xpath 'serverTime'
    @base_url     = URL.new url unless (url = frag.xpath('baseUrl').to_s).nil?
  end
end

# Simple structure for a time and time zone; only used by JIRA::ServerInfo
# objects, which themselves are only created when {RemoteAPI#get_server_info}
# is called.
class TimeInfo
  # @return [Time]
  attr_reader :server_time
  # @return [String]
  attr_reader :timezone

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag)
    @server_time = Time.parse frag.xpath('serverTime').to_s
    @timezone    = frag.xpath('timeZoneId').to_s
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
    super frag
    @name = frag.xpath('name').to_s
  end
end

# Represents an instance of a custom field (with values). This object is used
# primarily as a member of {JIRA::Issue} objects.
# @todo see if @key is always nil from the server
class CustomFieldValue < JIRA::DynamicEntity
  # @return [String]
  attr_accessor :key
  # @return [[String]]
  attr_accessor :values

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return if frag.nil?
    @id     = frag.xpath('customfieldId').to_s
    @key    = frag.xpath('key').to_s
    @values = frag.xpath('values/*').map { |value| value.to_s }
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
  # @return [String]
  attr_accessor :type
  # @return [String]
  attr_accessor :content_type
  # @return [String]
  attr_accessor :base64_data
  # @return [boolean] indicates if the image is the system default
  attr_accessor :system

  # @return [boolean] true if avatar is the default system avatar, else false
  def system?; @system; end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return if frag.nil?
    super frag
    @owner        = frag.xpath('owner').to_s
    @system       = frag.xpath('system').to_s == 'true'
    @type         = frag.xpath('type').to_s
    @content_type = frag.xpath('contentType').to_s
    @base64_data  = frag.xpath('base64Data').to_s
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
    return if frag.nil?
    super frag
    date = nil
    @original_author = frag.xpath('author').to_s
    @body            = frag.xpath('body').to_s
    @group_level     = frag.xpath('updateAuthor').to_s
    @role_level      = frag.xpath('roleLevel').to_s
    @update_author   = frag.xpath('updateAuthor').to_s
    @create_date     = Time.xmlschema date unless (date = frag.xpath('created').to_s).nil?
    @last_updated    = Time.xmlschema date unless (date = frag.xpath('updated').to_s).nil?
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
    return if frag.nil?
    super frag
    date = nil
    @affects_versions    = frag.xpath('affectsVersions/*').map { |frag| Version.new frag }
    @fix_versions        = frag.xpath('fixVersions/*').map { |frag| Version.new frag }
    @components          = frag.xpath('components/*').map { |frag| Component.new frag }
    @custom_field_values = frag.xpath('customFieldValues/*').map { |frag| CustomFieldValue.new frag }
    @attachment_names    = frag.xpath('attachmentNames/*').map { |name| name.to_s }
    @key                 = frag.xpath('key').to_s
    @summary             = frag.xpath('summary').to_s
    @description         = frag.xpath('description').to_s
    @type_id             = frag.xpath('type').to_s
    @votes               = frag.xpath('votes').to_s.to_i
    @status_id           = frag.xpath('status').to_s
    @assignee_name       = frag.xpath('assignee').to_s
    @reporter_name       = frag.xpath('reporter').to_s
    @priority_id         = frag.xpath('priority').to_s
    @project_name        = frag.xpath('project').to_s
    @resolution_id       = frag.xpath('resolution').to_s
    @environment         = frag.xpath('environment').to_s
    @last_updated        = Time.xmlschema date unless (date = frag.xpath('updated').to_s).nil?
    @create_date         = Time.xmlschema date unless (date = frag.xpath('updated').to_s).nil?
    @due_date            = Time.xmlschema date unless (date = frag.xpath('updated').to_s).nil?
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
    super frag
    @description = frag.xpath('description').to_s
  end
end

# Represents a field mapping.
class Field < JIRA::NamedEntity
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return if frag.nil?
    super frag
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
    return if frag.nil?
    super frag
    date = nil
    @sequence     = frag.xpath('sequence').to_s.to_i
    @released     = frag.xpath('released').to_s == 'true'
    @archived     = frag.xpath('archived').to_s == 'true'
    @release_date = Time.xmlschema date unless (date = frag.xpath('releaseDate').to_s).nil?
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

# Represents a component description for a project. It does not include
# the component lead.
class Component < JIRA::NamedEntity
  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return if frag.nil?
    super frag
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
    return if frag.nil?
    super frag
    date = nil
    @author      = frag.xpath('author').to_s
    @filename    = frag.xpath('filename').to_s
    @file_size   = frag.xpath('filesize').to_s.to_i
    @mime_type   = frag.xpath('mimetype').to_s
    @create_date = Time.xmlschema date unless (date = frag.xpath('created').to_s).nil?
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
  attr_accessor :description

  # @return [String]
  def type
    self.class.to_s
  end

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return if frag.nil?
    super frag
    @description = frag.xpath('description').to_s
  end
end


  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
    super frag
  end
end

# @todo find out what @project is supposed to be for
  # @return [String]
  attr_accessor :author
  # @return [String]
  attr_accessor :project
  # @return [nil]
  attr_accessor :xml

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize(frag = nil)
    return if frag.nil?
    super frag
    @author      = frag.xpath('author').to_s
    @project     = frag.xpath('project').to_s
    @xml         = frag.xpath('xml').to_s
  end
end

end
