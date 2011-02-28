jiraSOAP - Ruby interface to the JIRA SOAP API
==============================================

Uses [handsoap](http://wiki.github.com/unwire/handsoap/) to build a client for the JIRA SOAP API that works on MacRuby as well as Ruby 1.9.


Documentation
=============

Third party documentation is provided by http://rdoc.info/; you can
see either the [latest release](http://rubydoc.info/gems/jiraSOAP/) or
the [HEAD commit](http://rdoc.info/github/Marketcircle/jiraSOAP/master/frames).
The meat of the service is in the `RemoteAPI` module.

However, third party hosting does not allow for extensions to be run,
and jiraSOAP needs its extension to run in order to see attributes for
classes that inherit from {JIRA::Entity}. To get the full
documentation you will need to run your own documentation server;
which is actually very easy.

You just need to install the yard gem:

    gem install yard

Then you run the server:

     yard server --gems  # if you have jiraSOAP as a gem
     yard server         # if you are in the jiraSOAP source directory


Motivation
----------

The `jira4r` gem already exists, and works well on Ruby 1.8, but is not compatible with Ruby 1.9 or MacRuby due to its dependance on `soap4r`.


Goals
-----

Pick up where `jira4r` left off:

- Implement the current API; `jira4r` does not implement APIs from JIRA 4.x
   * not including APIs that have been deprecated in JIRA 4.x
- More natural interface; not adhering to the API when the API is weird
- Speed; network latency is bad enough
- Excellent documentation, since the documentation given by Atlassian can be terse (the newer APIs are well documented)


Getting Started
---------------

`jiraSOAP` should run on Ruby 1.9.2 and MacRuby 0.8 or newer. It is available through rubygems or you can build from source:

        # Using rubygems
        gem install jiraSOAP

        # Building from source
        git clone git://github.com/Marketcircle/jiraSOAP.git
        rake build install

Once installed, you can run a quick demo (making appropriate substitutions):

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
  + Needs a lot of mock data


Note on Patches/Pull Requests
-----------------------------

This project has a tendancy to change drastically between releases as it
is still unstable, so patches may not cleanly apply.

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

Copyright: [Marketcircle Inc.](http://www.marketcircle.com/), 2010-2011

See LICENSE.txt for details.
