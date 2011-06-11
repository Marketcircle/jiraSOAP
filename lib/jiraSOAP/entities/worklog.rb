##
# Contains the data and metadata for a remote worklog.
class JIRA::Worklog < JIRA::DescribedEntity

  # @return [String]
  add_attribute :comment, 'comment', :content

  ##
  # @todo Why does this need to be a DateTime? It should be a Time object
  #       so that it can be compatible with Cocoa's NSDate on MacRuby.
  #
  # Needs to be a DateTime.
  #
  # @return [DateTime]
  add_attribute :start_data, 'startDate', :to_date

  # @return [String]
  add_attribute :time_spent, 'timeSpent', :content

  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for msg
    msg.add 'comment', @comment
    msg.add 'startDate', @start_date
    msg.add 'timeSpent', @time_spent
  end

end
