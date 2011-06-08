##
# @note Issues with an UNRESOLVED status will have nil for the value for
#       {#resolution_id}.
# @todo Add attributes for the comments and the attachment metadata
#
# Contains most of the data and metadata for a JIRA issue, but does
# not contain the {JIRA::Comment}s or {JIRA::AttachmentMetadata}.
#
# This class is easily the most convoluted structure in the API, and will
# likely be the greatest source of bugs. The irony of the situation is that
# this structure is also the most critical to have in working order.
class JIRA::Issue < JIRA::DynamicEntity

  # @return [String]
  add_attribute :key, 'key', :content

  # @return [String]
  add_attribute :summary, 'summary', :content

  # @return [String]
  add_attribute :description, 'description', :content

  # @return [String]
  add_attribute :type_id, 'type', :content

  # @return [String]
  add_attribute :status_id, 'status', :content

  # @return [String]
  add_attribute :assignee_username, 'assignee', :content

  # @return [String]
  add_attribute :reporter_username, 'reporter', :content

  # @return [String]
  add_attribute :priority_id, 'priority', :content

  # @return [String]
  add_attribute :project_name, 'project', :content

  # @return [String]
  add_attribute :resolution_id, 'resolution', :content

  # @return [String]
  add_attribute :environment, 'environment', :content

  # @return [Number]
  add_attribute :votes, 'votes', :to_i

  # @return [Time]
  add_attribute :last_updated_time, 'updated', :to_iso_date

  # @return [Time]
  add_attribute :create_time, 'created', :to_iso_date

  ##
  # This is actually a Time object with no time resolution.
  #
  # @return [Time]
  add_attribute :due_date, 'duedate', :to_iso_date

  # @return [Array<JIRA::Version>]
  add_attribute :affects_versions, 'affectsVersions', [:children_as_objects, JIRA::Version]

  # @return [Array<JIRA::Version>]
  add_attribute :fix_versions, 'fixVersions', [:children_as_objects, JIRA::Version]

  # @return [Array<JIRA::Component>]
  add_attribute :components, 'components', [:children_as_objects, JIRA::Component]

  # @return [Array<JIRA::CustomFieldValue>]
  add_attribute :custom_field_values, 'customFieldValues', [:children_as_objects, JIRA::CustomFieldValue]

  # @return [Array<String>]
  add_attribute :attachment_names, 'attachmentNames', :contents_of_children


  [ 'id', 'key', 'status', 'resolution', 'votes', 'updated', 'created',
    'attachmentNames' ].each { |attr| @build.delete(attr) }

  ##
  # @todo see if we can use the simple and complex array builders
  #
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
  # To get the automatic assignee we pass `'-1'` as the value for @assignee.
  #
  # Passing an environment/due date field with a value of nil causes the
  # server to complain about the formatting of the message.
  #
  # @param [Handsoap::XmlMason::Node] msg  message the node to add the object to
  def soapify_for msg
    super

    # requires hacks
    msg.add 'assignee', (@assignee_name || '-1')
    msg.add 'environment', @environment if @environment
    msg.add_complex_array 'customFieldValues', (@custom_field_values || [])
    msg.add 'duedate', @due_date.xmlschema if @due_date

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
    end
  end
end
