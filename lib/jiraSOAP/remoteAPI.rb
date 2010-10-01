module RemoteAPI
  ResponseXPath = '/node()[1]/node()[1]/node()[1]/node()[2]'

  #TODO: these methods look generalizable because they are
  def login(user, password)
    resp = invoke('soap:login') { |m|
      m.add 'soap:in0', user
      m.add 'soap:in1', password
    }
    @authToken = resp.document.xpath('//loginReturn').first.to_s
    #TODO: error handling (catch the exception and look at the Response node?)
  end

  def logout
    resp = invoke('soap:logout') { |m| m.add 'soap:in0', @authToken }
    resp.document.xpath('//logoutReturn').first.to_s == 'true'
  end

  def getPriorities
    resp = invoke('soap:getPriorities') { |m| m.add 'soap:in0', @authToken }
    resp.document.xpath("#{ResponseXPath}/getPrioritiesReturn").map { |p|
      JIRA::Priority.new p
    }
  end

  def getResolutions
    resp = invoke('soap:getResolutions') { |m| m.add 'soap:in0', @authToken }
    resp.document.xpath("#{ResponseXPath}/getResolutionsReturn").map { |r|
      JIRA::Resolution.new r
    }
  end

  def getCustomFields
    resp = invoke('soap:getCustomFields') { |m| m.add 'soap:in0', @authToken }
    resp.document.xpath("#{ResponseXPath}/getCustomFieldsReturn").map { |cf|
      JIRA::Field.new cf
    }
  end

   def getIssueTypes
     resp = invoke('soap:getIssueTypes') { |m| m.add 'soap:in0', @authToken }
     resp.document.xpath("#{ResponseXPath}/getIssueTypesReturn").map { |it|
       JIRA::IssueType.new it
     }
   end

   def getStatuses
     resp = invoke('soap:getStatuses') { |m| m.add 'soap:in0', @authToken }
     resp.document.xpath("#{ResponseXPath}/getStatusesReturn").map { |s|
       JIRA::Status.new s
     }
   end

   def getNotificationSchemes
     resp = invoke('soap:getNotificationSchemes') { |m|
       m.add 'soap:in0', @authToken
     }
     resp.document.xpath("#{ResponseXPath}/getNotificationSchemesReturn").map { |s|
       JIRA::Scheme.new s
     }
   end

   def getVersions(key)
     resp = invoke('soap:getVersions') { |m|
       m.add 'soap:in0', @authToken
       m.add 'soap:in1', key
     }
     resp.document.xpath("#{ResponseXPath}/getVersionsReturn").map { |v|
       JIRA::Version.new v
     }
   end

   def getProjectByKey(key)
     resp = invoke('soap:getProjectByKey') { |m|
       m.add 'soap:in0', @authToken
       m.add 'soap:in1', key
     }
     JIRA::Project.new resp.document.xpath '//getProjectByKeyReturn'
   end

   def getIssuesFromJqlSearch(query, maxResults)
     resp = invoke('soap:getIssuesFromJqlSearch') { |m|
       m.add 'soap:in0', @authToken
       m.add 'soap:in1', query
       m.add 'soap:in2', maxResults
     }
     resp.document.xpath("#{ResponseXPath}/getIssuesFromJqlSearchReturn").map { |i|
       JIRA::Issue.new i
     }
   end

   def getUser(name)
     resp = invoke('soap:getUser') { |m|
       m.add 'soap:in0', @authToken
       m.add 'soap:in1', name
     }
     JIRA::User.new resp.document.xpath '//getUserReturn'
   end

   #TODO: make this look like less of a hack
   def updateIssue(key, fields)
     fields    = [fields] unless fields.kind_of? Array
     resp      = invoke('soap:updateIssue') { |m|
       m.add 'soap:in0', @authToken
       m.add 'soap:in1', key
       m.add 'soap:in2'  do |m|
         fields.map { |fv| fv.to_xml m }
       end
     }
     JIRA::Issue.new resp.document.xpath('//updateIssueReturn').first
   end

# #TODO: the last hurdle before a 0.1.0 release
#   def createIssue(issue)
#     fragment = jiraRequest :createIssue, issue
#   end

#TODO: next block of useful methods
# addBase64EncodedAttachmentsToIssue
# addComment
# addVersion
# archiveVersion
# createIssue
# createProject
# createProjectRole
# createUser
# deleteProjectAvatar
# deleteUser
# editComment
# getAttachmentsFromIssue
# getAvailableActions
# getComment
# getComments
# getComponents
# getFavouriteFilters
# getIssue
# getIssueById
# getIssueCountForFilter
# getIssuesFromFilterWithLimit
# getIssuesFromTextSearchWithLimit
# getIssueTypesForProject
# getProjectAvatars
# getProjectById
# getServerInfo
# getSubTaskIssueTypes
# getSubTaskIssueTypesForProject
# progressWorkflowAction
# refreshCustomFields
# releaseVersion
# setProjectAvatar (change to different existing)
# setNewProjectAvatar (upload new and set it)
# updateProject
# progressWorkflowAction
  def getProjectAvatar(key)
    resp = invoke('soap:getProjectAvatar') { |m|
      m.add 'soap:in0', @authToken
      m.add 'soap:in1', key
    }
    JIRA::Avatar.new resp.document.xpath '//getProjectAvatarReturn'
  end


end
