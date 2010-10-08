framework 'Foundation'

# work around curb not building for MacRuby (ticket #941)
Handsoap.http_driver = :net_http

class URL
  def initialize(url_string)
    @url = NSURL.URLWithString url_string
  end
end

module JIRA
  #overrides for MacRuby

end
