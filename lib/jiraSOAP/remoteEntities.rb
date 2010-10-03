module JIRA

class Priority
  attr_accessor :id, :name, :color, :icon, :description
  def initialize(frag = nil)
    return if frag == nil
    @id          = frag.xpath('id').to_s
    @name        = frag.xpath('name').to_s
    @color       = frag.xpath('color').to_s #PONDER: is a hex value so type is?
    @icon        = frag.xpath('icon').to_s #FIXME: NSURL
    @description = frag.xpath('description').to_s
  end
end

class Resolution
  attr_accessor :id, :name, :icon, :description
  def initialize(frag = nil)
    return if frag == nil
    @id          = frag.xpath('id').to_s
    @name        = frag.xpath('name').to_s
    @icon        = frag.xpath('icon').to_s #FIXME: NSURL
    @description = frag.xpath('description').to_s
  end
end

class Field
  attr_accessor :id, :name
  def initialize(frag = nil)
    return if frag == nil
    @id   = frag.xpath('id').to_s
    @name = frag.xpath('name').to_s
  end
end

class CustomField
  attr_accessor :customfieldId, :key, :values
  def initialize(frag = nil)
    return if frag == nil
    @customfieldId = frag.xpath('customfieldId').to_s
    @key           = frag.xpath('key').to_s
    @values        = frag.xpath('values/*').map { |v| v.to_s }
  end
  def soapify_for(message, label = 'customFieldValues')
    message.add label do |message|
      message.add 'customfieldId', @customfieldId
      message.add 'key', @key
      message.add_simple_array 'values', @values
    end
  end
end

class IssueType
  attr_accessor :id, :name, :icon, :subtask, :description
  def initialize(frag = nil)
    return if frag == nil
    @id          = frag.xpath('id').to_s
    @name        = frag.xpath('name').to_s
    @icon        = frag.xpath('icon').to_s #FIXME: NSURL
    @subtask     = frag.xpath('subtask').to_s == 'true'
    @description = frag.xpath('description').to_s
  end
end

class Status
  attr_accessor :id, :name, :icon, :description
  def initialize(frag = nil)
    return if frag == nil
    @id          = frag.xpath('id').to_s
    @name        = frag.xpath('name').to_s
    @icon        = frag.xpath('icon').to_s #FIXME: NSURL
    @description = frag.xpath('description').to_s
  end
end

class Version
  attr_accessor :id, :name, :sequence, :released, :archived, :releaseDate
  def initialize(frag = nil)
    #TODO: find out why we don't get a description field here
    return if frag == nil
    @id          = frag.xpath('id').to_s
    @name        = frag.xpath('name').to_s
    @sequence    = frag.xpath('sequence').to_s.to_i
    @released    = frag.xpath('released').to_s == 'true'
    @archived    = frag.xpath('archived').to_s == 'true'
    @releaseDate = frag.xpath('releaseDate').to_s #FIXME: NSDate
  end
end

class Scheme
  attr_accessor :id, :name, :type, :description
  def initialize(frag = nil)
    return if frag == nil
    @id          = frag.xpath('id').to_s
    @name        = frag.xpath('name').to_s
    @type        = frag.xpath('type').to_s
    @description = frag.xpath('description').to_s
  end
end

class Component
  attr_accessor :id, :name
  def initialize(frag = nil)
    return if frag == nil
    @id   = frag.xpath('id').to_s
    @name = frag.xpath('name').to_s
  end
end

class Project
  attr_accessor :id, :name, :key, :url, :projectUrl, :lead, :description
  attr_accessor :issueSecurityScheme, :notificationScheme, :permissionScheme
  def initialize(frag = nil)
    return if frag == nil
    @id                  = frag.xpath('id').to_s
    @name                = frag.xpath('name').to_s
    @key                 = frag.xpath('key').to_s
    @url                 = frag.xpath('url').to_s #FIXME: NSURL
    @projectUrl          = frag.xpath('projectUrl').to_s #FIXME: NSURL
    @lead                = frag.xpath('lead').to_s
    @description         = frag.xpath('description').to_s
    @issueSecurityScheme = Scheme.new frag.xpath('issueSecurityScheme')
    @notificationScheme  = Scheme.new frag.xpath('notificationScheme')
    @permissionScheme    = Scheme.new frag.xpath('permissionScheme')
  end
end

class Avatar
  attr_accessor :id, :owner, :system, :type, :contentType, :base64Data
  def initialize(frag = nil)
    return if frag == nil
    @id          = frag.xpath('id').to_s
    @owner       = frag.xpath('owner').to_s
    @system      = frag.xpath('system').to_s == 'true'
    @type        = frag.xpath('type').to_s
    @contentType = frag.xpath('contentType').to_s
    @base64Data  = frag.xpath('base64Data').to_s
  end
end

class Issue
  attr_accessor :id, :key, :summary, :description, :type, :updated, :votes
  attr_accessor :status, :assignee, :reporter, :priority, :project
  attr_accessor :affectsVersions, :created, :dueDate, :fixVersions, :resolution
  attr_accessor :environment, :components, :attachments, :customFieldValues
  def initialize(frag = nil)
    return if frag == nil
    @id               = frag.xpath('id').to_s
    @key              = frag.xpath('key').to_s
    @summary          = frag.xpath('summary').to_s
    @description      = frag.xpath('description').to_s
    @type             = frag.xpath('type').to_s
    @updated          = frag.xpath('updated').to_s
    @votes            = frag.xpath('votes').to_s.to_i
    @status           = frag.xpath('status').to_s
    @assignee         = frag.xpath('assignee').to_s
    @reporter         = frag.xpath('reporter').to_s
    @priority         = frag.xpath('priority').to_s
    @project          = frag.xpath('project').to_s
    @affectsVersions  = frag.xpath('affectsVersions/*').map { |v|
      Version.new v
    }
    @created          = frag.xpath('created').to_s #FIXME: NSDate
    @dueDate          = frag.xpath('duedate').to_s #FIXME: NSDate
    @fixVersions      = frag.xpath('fixVersions/*').map { |v|
      Version.new v
    }
    @resolution       = frag.xpath('resolution').to_s
    @environment      = frag.xpath('environment').to_s
    @components       = frag.xpath('components/*').map { |c|
      Component.new c
    }
    @attachments      = frag.xpath('attachmentNames/*').map { |a|
      #PONDER: needs its own type?
      a.to_s
    }
    @customFieldValues = frag.xpath('customFieldValues/*').map { |cfv|
      CustomField.new cfv
    }
  end
  def soapify_for(msg)
    #can you spot the oddities and inconsistencies?
    #we don't both including fields that are ignored
      #I tried to only ignore fields that will never be needed at creation
      #but I may have messed up. It should be easy to fix :)
    #we don't wrap the whole thing in 'issue' tags
    #-1 is the value you send to get the automatic assignee
    msg.add 'reporter', @reporter unless @reporter.nil?

    msg.add 'priority', @priority
    msg.add 'type', @type
    msg.add 'project', @project

    msg.add 'summary', @summary
    msg.add 'description', @description

    unless @components.nil?
      msg.add 'components' do |submsg|
        @components.each { |c|
          submsg.add 'components' do |id| id.add 'id', c.id end
        }
      end
    end
    unless @affectsVersions.nil?
      msg.add 'affectsVersions' do |submsg|
        @affectsVersions.each { |v|
          submsg.add 'affectsVersions' do |id| id.add 'id', v.id end
        }
      end
    end
    msg.add_complex_array 'customFieldValues', @customFieldValues unless @customFieldValues.nil?

    unless @fixVersions.nil?
      msg.add 'fixVersions' do |submsg|
        @fixVersions.each { |v|
          submsg.add 'fixVersions' do |id| id.add 'id', v.id end
        }
      end
    end
    msg.add 'assignee', (@assignee || '-1')

    msg.add 'environment', @environment unless @environment.nil?
    msg.add 'duedate', @dueDate unless @dueDate.nil?
  end
end

class User
  attr_accessor :name, :fullName, :email
  def initialize(frag = nil)
    return if frag == nil
    @name     = frag.xpath('name').to_s
    @fullName = frag.xpath('fullname').to_s
    @email    = frag.xpath('email').to_s
  end
end

class FieldValue
  attr_accessor :id, :values
  def self.fieldValueWithNilValues(id)
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
