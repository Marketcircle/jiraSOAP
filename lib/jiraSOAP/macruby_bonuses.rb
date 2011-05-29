##
# In the case of MacRuby, we extend NSURL to behave enough like a
# URI::HTTP object that they can be interchanged.
class NSURL
  alias_method :to_s, :absoluteString
end

module JIRA
  @url_class       = NSURL
  @url_init_method = :'URLWithString:'
end

# @todo get a parallel map method for collections
