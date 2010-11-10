framework 'Foundation'

class URL
  def initialize(url_string)
    @url = NSURL.URLWithString url_string
  end

  def to_s
    @url.absoluteString
  end
end

module JIRA
  #overrides for MacRuby

end
