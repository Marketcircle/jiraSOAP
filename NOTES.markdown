To get a reference for the API, you can look at the JavaDoc stuff provided by Atalssian [here](http://docs.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/soap/JiraSoapService.html).

There are some deviations from the JavaDoc APIs to note:

1. You never need to pass the token parameter to a method, this will always be done for you. The value of your authorization token is cached when you login, it is stored in the @authToken attribute.

2. jiraSOAP does not put the Remote prefix in front of each type (e.g. RemoteIssue). Instead, you would just use Issue, which is in the JIRA module (so technically it would be JIRA::Issue).

3. The type used for id members is not consistent in the JIRA SOAP API. In most places it is given as a string, but in some places it is a long. Custom fields also have a special prefix for their id field; they always start with customfield_ and are therefore strings. There are some APIs that can take a regular id or a customfield_ id (such as the updateIssue method) and because the API needs to work with any language (and hence any type strictness), they chose to make ids strings (why some are longs in some cases is beyond me (bug?)).
In any case, jiraSOAP should always give you strings for an id (or customfield_ id), it is a bug if it does not.

4. All instance variables should use camel case in jiraSOAP, if it doesn't then it is a bug.
