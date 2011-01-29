# Normally this variable is set to URI, but with MacRuby it is set to NSURL
# @return [Class]
$url             = URI

# We also need a variable for the init method for a URL object
# @return [Symbol]
$url_init_method = :parse
