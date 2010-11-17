module JIRA

# Contains the basic information about a user. The only things missing here
# are the permissions and login statistics.
class User < JIRA::Entity

  # @return [String]
  attr_accessor :username

  # @return [String]
  attr_accessor :full_name

  # @return [String]
  attr_accessor :email_address

  # @param [Handsoap::XmlQueryFront::NokogiriDriver] frag
  def initialize_with_xml_fragment(frag)
    @username, @full_name, @email_address =
      frag.nodes ['name', :to_s], ['fullname', :to_s], ['email', :to_s]
  end
end

end
