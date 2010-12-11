jiraSOAP - Ruby interface to the JIRA SOAP API
==============================================

Uses [handsoap](http://wiki.github.com/unwire/handsoap/) to build a client for the JIRA SOAP API that works on MacRuby as well as Ruby 1.9.

Read the documentation [here](http://rdoc.info/github/Marketcircle/jiraSOAP/master/frames). The meat of the service is in the `RemoteAPI` module.


Motivation
----------

The `jira4r` gem already exists, and works well on Ruby 1.8, but is not compatible with Ruby 1.9 or MacRuby due to its dependance on `soap4r`.


Goals
-----

Pick up where `jira4r` left off:

- Implement the current API; `jira4r` does not implement APIs from JIRA 4.x
- More natural interface; not adhering to the API when the API is weird
- Speed; network latency is bad enough
- Excellent documentation, since the documentation given by Atlassian is so terse


Getting Started
---------------

`jiraSOAP` should run on Ruby 1.9.2 and MacRuby 0.8. You can install it using `gem`, or build from source:

        git clone git://github.com/Marketcircle/jiraSOAP.git
        rake build
        rake install

Once that ugliness is over with, you can run a quick demo (making appropriate substitutions):

     require 'jiraSOAP'

     db = JIRA::JIRAService.new 'http://jira.yourSite.com:8080'
     db.login 'user', 'password'

     issues = db.get_issues_from_jql_search 'reporter = currentUser()', 100
     issues.each { |issue|
       #do something...
       puts issue.key
     }

     db.logout


TODO
----

- Finish implementing all of the API
- Stabilize API
- Performance optimizations; there are a number of places that can be optimized
  + Using GCD/Threads for parsing arrays of results; a significant speed up for large types and large arrays (ie. creating issues from JQL searches)
- Public test suite
  + Needs a mock server


Note on Patches/Pull Requests
-----------------------------

This project has a tendancy to change drastically between releases as it
is still unstable, so patches may not cleanly apply. It may be better to
just open an issue.

If you want to help by submitting patches:

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
  bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.


License
-------

Copyright: [Marketcircle Inc.](http://www.marketcircle.com/), 2010

See LICENSE for details.
