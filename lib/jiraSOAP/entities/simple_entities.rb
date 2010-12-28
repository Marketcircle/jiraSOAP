module JIRA

  # @abstract Anything that can be configured has an id field.
  class DynamicEntity < JIRA::Entity
    add_attributes({ 'id' => [:id=, :to_s] })

    # @return [String] usually a numerical value, but sometimes
    #  prefixed with a string (e.g. '12450' or 'customfield_10000')
    attr_accessor :id
  end


  # @abstract Most dynamic entities also have a name
  class NamedEntity < JIRA::DynamicEntity
    add_attributes({ 'name' => [:name=, :to_s] })

    # @return [String] a plain language name
    attr_accessor :name
  end


  # @abstract Some named entities have a short description
  class DescribedEntity < JIRA::NamedEntity
    add_attributes({ 'description' => [:description=, :to_s] })

    # @return [String] usually a short blurb
    attr_accessor :description
  end


  # Represents a field mapping.
  class Field < JIRA::NamedEntity
    add_attributes({})
  end


  # Represents a component description for a project. It does not include
  # the component lead.
  class Component < JIRA::NamedEntity
    add_attributes({})
  end


  # Contains only the basic information about a user. The only things missing here
  # are the permissions and login statistics, but these are not given in the API.
  class User < JIRA::Entity
    add_attributes({
      'name'     => [:username=,      :to_s],
      'fullname' => [:full_name=,     :to_s],
      'email'    => [:email_address=, :to_s]
    })

    # @return [String]
    attr_accessor :username

    # @return [String]
    attr_accessor :full_name

    # @return [String]
    attr_accessor :email_address
  end


  # Represents a filter, but does not seem to include the filters JQL query.
  class Filter < JIRA::DescribedEntity
    add_attributes({
      'author'  => [:author=,       :to_s],
      'project' => [:project_name=, :to_s],
      'xml'     => [:xml=,          :to_s]
    })

    # @return [String]
    attr_accessor :author

    # @return [String]
    attr_accessor :project_name

    # @return [nil]
    attr_accessor :xml
  end

end
