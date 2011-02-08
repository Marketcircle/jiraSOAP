module JIRA

  class << self

    # Normally this variable is set to URI, but with MacRuby it is
    # set to NSURL
    # @return [Class,Module]
    attr_accessor :url_class

    # We also need a variable for the init method for a URL object
    # @return [Symbol]
    attr_accessor :url_init_method

  end

  @url_class       = URI
  @url_init_method = :parse

end
