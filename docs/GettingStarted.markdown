 Getting Started
===============

`jiraSOAP` should run on Ruby 1.9.2+ and MacRuby 0.8+. It is available through rubygems or you can build from source:

    # Using rubygems
    gem install jiraSOAP

    # Building from source
    git clone git://github.com/Marketcircle/jiraSOAP.git
    rake build install

Once installed, you can run a quick demo (making appropriate substitutions):

    require 'jiraSOAP'

The first thing that you need to do is create a JIRAService object:

    db = JIRA::JIRAService.new 'http://jira.yourSite.com:8080'

Then you need to log in (a failed login will raise an exception):

    db.login 'mrada', 'secret'

Once you are logged in, you can start querying the server for information:

     issues = db.get_issues_from_jql_search 'reporter = currentUser()', 100
     issues.each { |issue|
       #do something...
       puts issue.key
     }

Don't forget to log out when you are done:

    db.logout

