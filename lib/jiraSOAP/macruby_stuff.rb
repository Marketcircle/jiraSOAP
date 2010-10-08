Handsoap.http_driver = :net_http  #curb does not build for MacRuby
framework 'Foundation'

class URL
  def initialize(url_string)
    @url = NSURL.URLWithString url_string
  end
end

module JIRA
  #overrides for MacRuby

end
