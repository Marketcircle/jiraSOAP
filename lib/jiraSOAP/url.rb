# A bit of a hack to support using an NSURL in MacRuby while still supporting
# MRI by using the URI module.
#
# For any JIRA entity that has a URL object as an instance variable, you can
# stick whatever type of object you want in the instance varible, as long as
# the object has a #to_s method that returns a properly formatted URI.
class URL

  # @return [NSURL, URI::HTTP] the type depends on your RUBY_ENGINE
  attr_accessor :url

  # Initializes @url with the correct object type.
  # @param [String] url string to turn into some kind of URL object
  # @return [URI::HTTP,NSURL] URI::HTTP on CRuby, NSURL on MacRuby
  def initialize(url)
    @url = URI.parse url
  end

  # The #to_s method technically exists and so method_missing would not
  # work its magic to redirect it to @url so we manually override.
  # @return [String]
  def to_s
    @url.to_s
  end

  # The magic of the hack, passing everything to the level beneath.
  def method_missing(method, *args)
    @url.send method, *args
  end
end
