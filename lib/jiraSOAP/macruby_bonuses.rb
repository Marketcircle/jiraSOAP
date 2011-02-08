framework 'Foundation'

# In the case of MacRuby, we extend NSURL to behave enough like a
# URI::HTTP object that they can be interchanged.
class NSURL

  # We have to override, using alias_method does not work because
  # {#to_s} is defined in the base class.
  # @return [String]
  def to_s
    absoluteString
  end

end


# @todo get a parallel map method for collections
module JIRA

  @url_class       = NSURL
  @url_init_method = :'URLWithString:'

end
