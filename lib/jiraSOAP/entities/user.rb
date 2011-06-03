##
# Contains only the basic information about a user. The only things missing here
# are the permissions and login statistics, but these are not given in the API.
class JIRA::User < JIRA::UserName

  # @return [String]
  add_attribute :full_name, 'fullname', :content

  # @return [String]
  add_attribute :email_address, 'email', :content

end
