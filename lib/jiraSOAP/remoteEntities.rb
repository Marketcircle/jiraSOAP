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
  def self.priorityWithXMLFragment(frag)
    Priority.new frag
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
  def self.resolutionWithXMLFragment(frag)
    Resolution.new frag
  end
end

class Field
  attr_accessor :id, :name
  def initialize(frag = nil)
    return if frag == nil
    @id   = frag.xpath('id').to_s
    @name = frag.xpath('name').to_s
  end
  def self.fieldWithXMLFragment(frag)
    Field.new frag
  end
end

class CustomField
  attr_accessor :customfieldId, :type, :values
  def initialize(frag = nil)
    return if frag == nil
    @customfieldId = frag.xpath('customfieldId').to_s
    @type          = frag.xpath('type').to_s
    @values        = frag.xpath('values/*').map { |v| v.to_s }
  end
  def self.customFieldWithXMLFragment(frag)
    CustomField.new frag
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
  def self.issueTypeWithXMLFragment(frag)
    IssueType.new frag
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
  def self.statusWithXMLFragment(frag)
    Status.new frag
  end
end

class Version
  attr_accessor :id, :name, :sequence, :released, :archived, :releaseDate
  def initialize(frag = nil)
    return if frag == nil
    @id          = frag.xpath('id').to_s
    @name        = frag.xpath('name').to_s
    @sequence    = frag.xpath('sequence').to_s.to_i
    @released    = frag.xpath('released').to_s == 'true'
    @archived    = frag.xpath('archived').to_s == 'true'
    @releaseDate = frag.xpath('releaseDate').to_s #FIXME: NSDate
  end
  def self.versionWithXMLFragment(frag)
    Version.new frag
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
  def self.schemeWithXMLFragment(frag)
    Scheme.new frag
  end
end

class Component
  attr_accessor :id, :name
  def initialize(frag = nil)
    return if frag == nil
    @id   = frag.xpath('id').to_s
    @name = frag.xpath('name').to_s
  end
  def self.componentWithXMLFragment(frag)
    Component.new frag
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
  def self.projectWithXMLFragment(frag)
    Project.new frag
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
  def self.avatarWithXMLFragment(frag)
    Avatar.new frag
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
  def self.issueFromXMLFragment(frag)
    Issue.new frag
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
  def self.userWithXMLFragment(frag)
    User.new frag
  end
end

class FieldValue
  attr_accessor :id, :values
  def initialize(frag = nil)
    #PONDER: do I need to initialize this from an XML fragment?
  end
  def self.fieldValueWithXMLFragment(frag)
    FieldValue.new frag
  end
  def to_xml(message)
    #TODO: tidy this up
    message.add 'fieldValue' do |dude|
      dude.add 'id', @id
      dude.add 'values' do |duder| @values.each { |v| duder.add 'value', v } end
    end
  end
end

end
