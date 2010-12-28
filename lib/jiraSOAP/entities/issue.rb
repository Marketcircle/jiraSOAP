module JIRA

# Contains most of the data and metadata for a JIRA issue, but does
# not contain the {JIRA::Comment}'s or {JIRA::AttachmentMetadata}.
#
# This class is easily the most convoluted structure in the API, and will
# likely be the greatest source of bugs. The irony of the situation is that
# this structure is also the most critical to have in working order.
#
# Issues with an UNRESOLVED status will have nil for the value of @resolution.
class Issue < JIRA::DynamicEntity
  add_attributes({
    'key'               => [:key=,                 :to_s],
    'summary'           => [:summary=,             :to_s],
    'description'       => [:description=,         :to_s],
    'type'              => [:type_id=,             :to_s],
    'status'            => [:status_id=,           :to_s],
    'assignee'          => [:assignee_name=,       :to_s],
    'reporter'          => [:reporter_name=,       :to_s],
    'priority'          => [:priority_id=,         :to_s],
    'project'           => [:project_name=,        :to_s],
    'resolution'        => [:resolution_id=,       :to_s],
    'environment'       => [:environment=,         :to_s],
    'votes'             => [:votes=,               :to_i],
    'duedate'           => [:due_date=,            :to_date],
    'affectsVersions'   => [:affects_versions=,    :to_objects, JIRA::Version],
    'fixVersions'       => [:fix_versions=,        :to_objects, JIRA::Version],
    'components'        => [:components=,          :to_objects, JIRA::Component],
    'customFieldValues' => [:custom_field_values=, :to_objects, JIRA::CustomFieldValue],
    'attachmentNames'   => [:attachment_names=,    :to_ss]
  })

  # @return [String]
  attr_accessor :key

  # @return [String]
  attr_accessor :summary

  # @return [String]
  attr_accessor :description

  # @return [String]
  attr_accessor :type_id

  # @return [Fixnum]
  attr_accessor :votes

  # @return [String]
  attr_accessor :status_id

  # @return [String]
  attr_accessor :assignee_name

  # @return [String]
  attr_accessor :reporter_name

  # @return [String]
  attr_accessor :priority_id

  # @return [String]
  attr_accessor :project_name

  # @return [[JIRA::Version]]
  attr_accessor :affects_versions

  # @return [Time]
  attr_accessor :due_date

  # @return [[JIRA::Version]]
  attr_accessor :fix_versions

  # @return [String]
  attr_accessor :resolution_id

  # @return [String]
  attr_accessor :environment

  # @return [[JIRA::Component]]
  attr_accessor :components

  # @return [[String]]
  attr_accessor :attachment_names

  # @return [[JIRA::CustomFieldValue]]
  attr_accessor :custom_field_values

  # Generate the SOAP message fragment for an issue. Can you spot the oddities
  # and inconsistencies? (hint: there are many).
  #
  # We don't bother including fields that are ignored. I tried to only
  # ignore fields that will never be needed at creation time, but I may have
  # messed up.
  #
  # We don't wrap the whole thing in 'issue' tags for
  # {#RemoteAPI#create_issue_with_issue} calls; this is an inconsistency in the
  # way jiraSOAP works and may need to be worked around for other {RemoteAPI}
  # methods.
  #
  # Servers only seem to accept issues if components/versions are just ids
  # and do not contain the rest of the {JIRA::Component}/{JIRA::Version}
  # structure.
  #
  # To get the automatic assignee we pass '-1' as the value for @assignee.
  #
  # Passing an environment/due date field with a value of nil causes the
  # server to complain about the formatting of the message.
  # @todo see if we can use the simple and complex array builders
  # @todo make this method shorter
  # @param [Handsoap::XmlMason::Node] msg  message the node to add the object to
  def soapify_for(msg)
    #might be going away, since it appears to have no effect at creation time
    msg.add 'reporter', @reporter_name unless @reporter.nil?

    msg.add 'priority', @priority_id
    msg.add 'type', @type_id
    msg.add 'project', @project_name

    msg.add 'summary', @summary
    msg.add 'description', @description

    msg.add 'components' do |submsg|
      (@components || []).each { |component|
        submsg.add 'components' do |component_msg|
          component_msg.add 'id', component.id
        end
      }
    end
    msg.add 'affectsVersions' do |submsg|
      (@affects_versions || []).each { |version|
        submsg.add 'affectsVersions' do |version_msg|
          version_msg.add 'id', version.id
        end
      }
    end
    msg.add 'fixVersions' do |submsg|
      (@fix_versions || []).each { |version|
        submsg.add 'fixVersions' do |version_msg|
          version_msg.add 'id', version.id end
      }
      'updated'           => [:last_updated_time=,   :to_date],
      'created'           => [:create_time=,         :to_date],
    # @return [Time]
    attr_accessor :last_updated_time

    end

    msg.add 'assignee', (@assignee_name || '-1')
    msg.add_complex_array 'customFieldValues', (@custom_field_values || [])

    msg.add 'environment', @environment unless @environment.nil?
    msg.add 'duedate', @due_date.xmlschema unless @due_date.nil?
  end
end


    # @return [Time]
    attr_accessor :create_time

end
