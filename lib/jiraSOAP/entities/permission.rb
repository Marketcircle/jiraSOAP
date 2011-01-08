class JIRA::Permission < JIRA::Entity
  add_attributes({
    'name'       => [:name=,       :to_s],
    'permission' => [:permission=, :to_i]
  })

  # @return [String] the permission type
  attr_accessor :name

  # @return [Fixnum] a unique id number
  attr_accessor :permission
end
