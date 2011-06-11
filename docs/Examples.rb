#!/usr/bin/env ruby
#

# This sample ruby program showcases ways to interact with JIRA application via
# JIRA's SOAP interface, adapted from the jira4r version of the script.

$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','lib','jiraSOAP','jiraSOAP')
require 'rubygems'
require 'jiraSOAP'

# Create a new JIRAService
#
# where:
# base_url ... the base URL of the JIRA instance - eg. http://confluence.atlassian.com
jira = JIRA::JIRAService.new 'http://jira.atlassian.com:8080'

jira.login 'soaptester', 'password'

# Get some information about the server
baseurl = jira.server_info.base_url
puts "Base URL: #{baseurl} \n"

# List all project keys
jira.projects.each { |project| puts project.key }

# Get details about a specific project
project_key     = 'DEMO'
project_details = jira.project_with_key project_key
puts "Details for project #{project_key}: #{project_details.inspect}"

# Get an issue given its key
issue_key = 'TST-10392'
issue     = jira.issue_with_key issue_key
puts "Retrieved issue: #{issue.key}"

# Get the value of a custom field
custom_field_id    = jira.custom_field_with_name('Reported on behalf of').id
custom_field_value = issue.custom_field_values.find do |field_value|
  field_value.id == 'customfield_10150'
end
puts "Value of issue #{issue.key}'s custom field with ID #{custom_field_id}: " +
  "#{custom_field_value}\n"

# Add a comment
comment = JIRA::Comment.new
comment.body = 'commented from jiraSOAP'
begin
  jira.add_comment_to_issue_with_key issue.key, comment
  puts "Added comment '#{comment.body}' in issue #{issue.key}\n"
rescue
end

# Update a field for an issue
summary = JIRA::FieldValue.new('summary', 'new summary info from jiraSOAP')
begin
  jira.update_issue issue.key, summary
  puts "Updated issue #{issue.key}'s field #{summary.name}\n"
rescue
end

# Create user
begin
  password = rand(1000000000000).to_s(16)
  user     = jira.create_user('jon', password, 'Jon Happy', 'jon@usa.com')
  puts "Created user #{user.username} with password: #{password}\n"
rescue
end

# Get details of a group
begin
  group = jira.group_with_name 'jira-users'
  puts "Retrieved details for group jira-users: #{group.inspect}\n"
rescue
end

# Add user to a group
begin
  newuser = JIRA::User.new
  newuser.name = user.name
  jira.add_user_to_group group, user
  puts "Added user #{user.name} in group #{group.name}\n"
rescue
end

# Add a new version
version = JIRA::Version.new
version.name = 'version 99'
begin
  new_version = jira.add_version_to_project_with_key project.key, version
  puts "Added version #{new_version.name} to #{project.name}\n"
rescue
end

# Last but not least
jira.logout
