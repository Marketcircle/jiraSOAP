class MyAttributeHandler < YARD::Handlers::Ruby::AttributeHandler
  handles method_call(:add_attributes)
  namespace_only # just to be safe

  # What we want to process:
  # an array that is a tuple
  #  first element is the JIRA name for the ivar
  #  second element is our name for the ivar
  #  third element is the type for the ivar
  #    types will then have a table that has a tuple pair
  #      first element is the XML parse method
  #      second element is the XML build method
  # we then use the tuple to call attr_accessor for the class
  # then to build the XML parse hash
  # then to build the XML builder hash

  process do
    puts statement.parameters(false).class
    puts namespace.attributes[scope].class
  end
end
