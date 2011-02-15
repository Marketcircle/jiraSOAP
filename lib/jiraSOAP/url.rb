module JIRA

  class << self

    # When running on MacRuby, a URL will be wrapped into an NSURL object;
    # but on all other Ruby implementations you will get a URI::HTTP object.
    # The NSURL class is monkey patched just enough to make NSURL and
    # URI::HTTP interchangeable. If you really want to, you can override
    # the wrapper by changing {JIRA.url_class} and {JIRA.url_init_method}
    # so that:
    #
    #     JIRA.url_class.send JIRA.url_init_method, 'http://marketcircle.com'
    #
    # will be working code.
    # @return [Class,Module]
    attr_accessor :url_class

    # We also need a variable for the init method for a URL object
    # @return [Symbol]
    attr_accessor :url_init_method

  end

  @url_class       = URI
  @url_init_method = :parse

end
