# A bit of a hack to support using an NSURL in MacRuby while still supporting
# MRI by using the URI module.
#
# I suggest not thinking about it too much beyond this point: this is a
# URI object if you are running on CRuby, but it will be an NSURL if you
# are running on MacRuby.
class URL
  attr_accessor :url

  # Initializes @url with the correct object type.
  # @param [String] url string to turn into some kind of URL object
  # @return [URI::HTTP,NSURL] URI::HTTP on CRuby, NSURL on MacRuby
  def initialize(url)
    @url = URI.parse url
  end

  # The magic of the hack, passing everything to the level beneath.
  def method_missing(method, *args)
    @url.send method, *args
  end
end
