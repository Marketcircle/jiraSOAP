class MyAttributeHandler < YARD::Handlers::Ruby::AttributeHandler
  handles method_call(:add_attributes)
  namespace_only # just to be safe


  process do
    puts statement.parameters(false).class
    puts namespace.attributes[scope].class
  end
end

# @todo add tasks section for RemoteAPI
