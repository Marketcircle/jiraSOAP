require 'jiraSOAP/entities/abstract'

module JIRA
  # Represents a field mapping.
  class Field < JIRA::NamedEntity
    add_attributes({})
  end

  # Represents a component description for a project. It does not include
  # the component lead.
  class Component < JIRA::NamedEntity
    add_attributes({})
  end
end

require 'jiraSOAP/entities/read_only'
require 'jiraSOAP/entities/field_value'
require 'jiraSOAP/entities/user'

require 'jiraSOAP/entities/avatar'
require 'jiraSOAP/entities/comment'

require 'jiraSOAP/entities/filter'
require 'jiraSOAP/entities/version'
require 'jiraSOAP/entities/attachments'

require 'jiraSOAP/entities/schemes'
require 'jiraSOAP/entities/issue_properties'

require 'jiraSOAP/entities/project'
require 'jiraSOAP/entities/issue'
