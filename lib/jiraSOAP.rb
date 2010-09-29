case RUBY_ENGINE
when 'macruby' then
  require 'macruby/JIRAservice.rb'
else
  require 'ruby/JIRAservice.rb'
end
