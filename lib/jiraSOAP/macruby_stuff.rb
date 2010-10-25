framework 'Foundation'

class URL
  def initialize(url_string)
    @url = NSURL.URLWithString url_string
  end

  alias_method absoluteString to_s
end

module JIRA
  #overrides for MacRuby

end
