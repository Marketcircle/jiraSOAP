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

`jiraSOAP` should run on Ruby 1.9.2 and MacRuby 0.7. Right now you need to build from source, it will be available from gemcutter sometime around the 0.1.0 or 0.2.0 release.

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

Get the [Gist](http://gist.github.com/612186).


Notes About Using This Gem
--------------------------

To get a reference for the API, you can look at the JavaDoc stuff provided by Atalssian [here](http://docs.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/soap/JiraSoapService.html).

1. All method names have been made to feel more natural in a Ruby setting. Consult the `jiraSOAP` documentation for specifics.

2. If an API call fails with a method missing error it is because the method has not been implement, yet. I started by implementing only the methods that I needed in order to port some old scripts that ran on jira4r; other methods will be added as them gem matures (or you could add it for me :D).

3. URESOLVED issues have a Resolution with a value of `nil`.

4. To empty a field (set it to nil) you can use this pattern:
   jira.update_issue 'JIRA-1', JIRA::FieldValue.fieldValueWithNilValues 'description'

5. Issue creation, using #create_issue_with_issue does not make use of all the fields in a JIRA::Issue. Which fields are used seems to depend on the version of JIRA you are connecting to.

6. RemoteAPI#update_issue wants an id for each field that you pass it, but it really wants the name of the field that you want to update. See this [Gist](http://gist.github.com/612562).


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
- Finish implementing all of the API


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
