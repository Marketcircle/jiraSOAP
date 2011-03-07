require 'net/http'

##
# Use this hack to capture raw data from JIRA. The net/http gem does not
# actually provide HTTP header data (at least not the way that handsoap
# expects it), so we also ignore it.
class Net::HTTP

  alias_method :original_start, :start

  def start &block
    response = original_start &block

    puts "\t\t---RETURN CODE: #{response.code}---"
    puts response.code
    puts "\n\t\t---START OF BODY---"
    puts response.body
    puts "\t\t---END OF BODY---"
    response
  end
end
