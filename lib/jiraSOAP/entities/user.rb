module JIRA

# Contains the basic information about a user. The only things missing here
# are the permissions and login statistics.
class User < JIRA::Entity
  add_attributes({
    'name' => [:username=, :to_s],
    'fullname' => [:full_name=, :to_s],
    'email' => [:email_address=, :to_s]
  })

  # @return [String]
  attr_accessor :username

  # @return [String]
  attr_accessor :full_name

  # @return [String]
  attr_accessor :email_address
end

end
