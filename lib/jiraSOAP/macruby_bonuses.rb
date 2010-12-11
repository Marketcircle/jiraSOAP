framework 'Foundation'

class URL
  def initialize(url_string)
    @url = NSURL.URLWithString url_string
  end

  def to_s
    @url.absoluteString
  end
end

# @todo get a parallel map method for collections
module JIRA

end
