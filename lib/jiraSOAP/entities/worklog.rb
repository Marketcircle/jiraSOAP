##
# Contains the data and metadata for a remote worklog.
class JIRA::Worklog < JIRA::DescribedEntity

  add_attributes(
    ['comment',   :comment,    :content],
    # Needs to be a DateTime
    ['startDate', :start_date, :to_date],
    ['timeSpent', :time_spent, :content]
  )

  # @param [Handsoap::XmlMason::Node] msg
  # @return [Handsoap::XmlMason::Node]
  def soapify_for msg
    msg.add 'comment', @comment
    msg.add 'startDate', @start_date
    msg.add 'timeSpent', @time_spent
  end

end
