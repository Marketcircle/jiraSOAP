module JIRA
module RemoteAPI
  # @group Working with Versions

  # @param [String] project_key
  # @return [Array<JIRA::Version>]
  def get_versions_for_project project_key
    array_jira_call JIRA::Version, 'getVersions', project_key
  end

  # New versions cannot have the archived bit set and the release date
  # field will ignore the time of day you give it and instead insert
  # the time zone offset as the time of day.
  #
  # Remember that the @release_date field is the tentative release date,
  # so its value is independant of the @released flag.
  #
  # Descriptions do not appear to be included with JIRA::Version objects
  # that SOAP API provides.
  # @param [String] project_key
  # @param [JIRA::Version] version
  # @return [JIRA::Version]
  def add_version_to_project_with_key project_key, version
    JIRA::Version.new_with_xml jira_call( 'addVersion', project_key, version )
  end

  # The archive state can only be set to true for versions that have not been
  # released. However, this is not reflected by the return value of this method.
  # @param [String] project_key
  # @param [String] version_name
  # @param [Boolean] state
  # @return [Boolean] true if successful
  def set_archive_state_for_version_for_project project_key, version_name, state
    jira_call 'archiveVersion', project_key, version_name, state
    true
  end

  # You can set the release state for a project with this method.
  # @param [String] project_name
  # @param [JIRA::Version] version
  # @return [Boolean] true if successful
  def release_state_for_version_for_project project_name, version
    jira_call 'releaseVersion', project_name, version
    true
  end

  # @endgroup
end
end

