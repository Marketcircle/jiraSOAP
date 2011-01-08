# Contains only the basic information about a user. The only things missing here
# are the permissions and login statistics, but these are not given in the API.
class JIRA::User < JIRA::UserName
  add_attributes(
    ['fullname', :full_name,     :to_s],
    ['email',    :email_address, :to_s]
  )
end
