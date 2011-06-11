# Examples

These snippets showcase ways to interact with a JIRA server via JIRA's
SOAP interface. The script was originally adapted from an example
script for jira4r.

## The first thing you need to do

Always start by creating a new {JIRA::JIRAService}, with the argument
being the base URL to your JIRA server
(e.g. http://confluence.atlassian.com):

    jira = JIRA::JIRAService.new 'http://jira.atlassian.com:8080'

Then you need to log in:

    jira.login 'soaptester', 'password'

Now the rest of the API is available to you.

## Server Information

You can get information about the server, such as its version, and
also information about its configuration, such as whether or not
voting on issues is allowed:

    baseurl = jira.server_info.base_url
    puts "Base URL: #{baseurl} \n"

    if jira.server_configuration.voting_allowed?
      puts 'Voting is allowed on this server'
    else
      puts 'Voting is not allowed on this server'
    end

## Project Information

Getting information about projects is also very easy, except for
information about schemes (i.e. permissions, etc.).

    # get every project
    projects = jira.projects.each { |project| puts project.inspect }

    # get a specific project
    project_key = 'DEMO'
    project = jira.project_with_key project_key
    puts "Details for project #{project_key}: #{project.inspect}"

### Project Versions

    version = JIRA::Version.new
    version.name = 'version 99'
    new_version = jira.add_version_to_project_with_key project.key, version
    puts "Added version #{new_version.name} to #{project.name}\n"

## Issues

There are many ways to get and issue from the server, I think the
easiest is to use the issue key.

    issue_key = 'TST-10392'
    issue = jira.issue_with_key issue_key
    puts "Retrieved issue: #{issue.key}: #{issue.summary}\n"

### Get the value of a custom field

I find that I often need to get information from an issue's custom fields.

    custom_field_id = jira.custom_field_with_name('Reported on behalf of').id
    custom_field_value = issue.custom_field(custom_field_id)
    puts "Value of issue #{issue.key}'s custom field with ID #{custom_field_id}: " +
      "#{custom_field_value}\n"

### Comment on an issue

It is also pretty easy to add a comment to an issue.

    comment = JIRA::Comment.new
    comment.body = 'commented from jiraSOAP'
    jira.add_comment_to_issue_with_key issue.key, comment

### Update a field for an issue

Updating an issue is easy, but has some caveats, so you should see the
documentation as well ({JIRA::RemoteAPI#update_issue}).

    summary = JIRA::FieldValue.new('summary', 'new summary info from jiraSOAP')
    jira.update_issue issue.key, summary
    puts "Updated issue #{issue.key}'s field #{summary.name}\n"

## User Information

CRUD operations for user information are also available.

    begin
      password = rand(1000000000000).to_s(16)
      user = jira.create_user('jon', password, 'Jon Happy', 'jon@usa.com')
      puts "Created user #{user.username} with password: #{password}\n"
    rescue
    end

### User groups

    # get details about a user group
    group = jira.group_with_name 'jira-users'
    puts "Retrieved details for group jira-users: #{group.inspect}\n"

    # add a user to a group
    newuser = JIRA::User.new
    newuser.name = user.name
    jira.add_user_to_group group, user
    puts "Added user #{user.name} in group #{group.name}\n"

## Don't forget to log out

Your session will timeout, but for security purposes it is always a
good idea to log out when you are done.

    jira.logout
