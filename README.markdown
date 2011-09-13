# jiraSOAP - Ruby interface to the JIRA SOAP API

Uses [handsoap](http://wiki.github.com/unwire/handsoap/) to build a
client for the JIRA SOAP API that works on Ruby 1.9 as well as MacRuby.

You can read the documentation for the
[latest release](http://rubydoc.info/gems/jiraSOAP/) or
the
[HEAD commit](http://rdoc.info/github/Marketcircle/jiraSOAP/master/frames).
The meat of the service is in the `RemoteAPI` module.


## Motivation

The `jira4r` gem already exists, and works well on Ruby 1.8, but is
not compatible with Ruby 1.9 or MacRuby due to its dependance on
`soap4r`.


## Goals

Pick up where `jira4r` left off:

- Implement the current API; `jira4r` does not implement APIs from JIRA 4.x
   * not including APIs that have been deprecated in JIRA 4.x
- More natural interface; not adhering to the API when the API is weird
- Speed; network latency is bad enough (it would be cool to roflscale)
- Excellent documentation


## Getting Started

See the {file:docs/GettingStarted.markdown Getting Started} guide.


## TODO


- Finish implementing all of the JIRA API
- Performance optimizations
  + Using GCD/Threads for parsing arrays of results; a significant
  speed up for large types and large arrays (ie. creating issues from
  JQL searches)
  + Parsing might be doable with array indexing instead of hash lookups
  + Use a different web driver backend (net/http is slow under load)
- ActiveRecord inspired conveniences
  + ProjectRole.new( 'test role' ).unique? # => check uniqueness
  + Issue.new( args ).create! # => creates a new issue
  + Issue.with_key( 'JIRA-123' ) # => returns result of issue lookup
  + Issue.new( args ).project # => returns a JIRA::Project


## Test Suite

The test suite relies on a specific JIRA server being available. Every
thing that might need to be configured has been abstracted to its own
method so that the values can easily be changed, but I will try to
provide a database backup in the near future if the licensing works out.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
  bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.


## License

Copyright: [Marketcircle Inc.](http://www.marketcircle.com/), 2010-2011

See LICENSE.txt for details.
