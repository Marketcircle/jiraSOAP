jiraSOAP - Ruby interface to the JIRA SOAP API
==============================================

Uses [handsoap](http://wiki.github.com/unwire/handsoap/) to build a client for the JIRA SOAP API that works on MacRuby as well as Ruby 1.9.


Motivation
----------

The `jira4r` gem already exists, and works well on Ruby 1.8, but is not compatible with Ruby 1.9 or MacRuby due to its dependance on `soap4r`.


Goals
-----

Pick up where `jira4r` left off:

- Implement the current API; `jira4r` does not implement APIs from JIRA 4.x
- More natural interface; not adhering to the API when the API is weird
- Speed; network latency is bad enough


Getting Started
---------------

        git clone git://github.com/Marketcircle/jiraSOAP.git
        rake build
        rake install

Once that ugliness is over with, you can run a quick demo (making appropriate substitutions):

     require 'jiraSOAP'

     db = JIRA::JIRAService.new 'http://jira.yourSite.com:8080'
     db.login 'user', 'password'

     issues = db.getIssuesFromJqlSearch 'reporter = currentUser()', 100
     issues.each { |issue|
       #do something...
       puts issue.key
     }

     db.logout

Get the [Gist](http://gist.github.com/602286).


Notes About Using This Gem
--------------------------

To get a reference for the API, you can look at the JavaDoc stuff provided by Atalssian [here](http://docs.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/soap/JiraSoapService.html).

There are some deviations from the JavaDoc APIs to note:

1. You never need to pass the token parameter to a method, this will always be done for you. The value of your authorization token is cached when you `login`, it is stored in the `@authToken` attribute.

2. `jiraSOAP` does not put the `Remote` prefix in front of each type (e.g. `RemoteIssue`). Instead, you would just use `Issue`, which is in the `JIRA` module (so technically it would be `JIRA::Issue`).

3. The type used for `id` members is not consistent in the JIRA SOAP API. In most places it is given as a string, but in some places it is a long. Custom fields also have a special prefix for their `id` field; they always start with `customfield_` and are therefore strings. There are some APIs that can take a regular `id` or a `customfield_` id (such as the `updateIssue` method) and because the API needs to work with any language (and hence any type strictness), they chose to make `id`s strings (why some are longs in some cases is beyond me (bug?)).
In any case, `jiraSOAP` should always give you strings for an `id` (or `customfield_` id); it is a bug if it does not.

4. All instance variables should use camel case in `jiraSOAP`, if it doesn't then it is a bug.


TODO
----

- Performance optimizations; there are a number of places that can be optimized
  + Using GCD/Threads for parsing arrays of results; a significant speed up for large types and large arrays (ie. creating issues from JQL searches)
- Refactor for a smaller code base
- Fix type hacks;. dates should be `NSDate`s and URLs should be `NSURL`s, right now they are all strings
- Public test suite
  + Needs a mock server
- Documentation
- Error handling


Note on Patches/Pull Requests
-----------------------------

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
