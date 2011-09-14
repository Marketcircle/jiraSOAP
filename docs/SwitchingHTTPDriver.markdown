# Switch HTTP Drivers

By default, `jiraSOAP` tells `handsoap` to use the `net/http` driver
for all HTTP work. This is done so that `jiraSOAP` will work
out-of-the-box with other Ruby implementations, namely
MacRuby. However, `net/http` is slow compared to the other
available HTTP drivers.

Switching to another, more performant, HTTP driver is advisable to get
the maximum roflscale performance from `jiraSOAP`. The HTTP driver is
handled entirely by `handsoap`, and is very easy change, you just need
to make sure that you have loaded `jiraSOAP` first and then tell
`handsoap` to use a different driver. An example would look like this:

     require 'rubygems'
     require 'jiraSOAP'
     Handsoap.http_driver = :curb

Which would change the driver to the `curb` gem. There are other
drivers available, and an up to date list is maintained in the
`handsoap` [README](https://github.com/unwire/handsoap).

__Note__: I only run the full test suite using `net/http`, but other
drivers should be drop-in replacements that require no changes to
`jiraSOAP` itself (with the exception of `eventmachine`).
