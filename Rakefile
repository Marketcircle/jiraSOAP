require 'rubygems'

task :default => :test


### MACRUBY BONUSES

if RUBY_ENGINE == 'macruby'
  require 'rake/compiletask'
  Rake::CompileTask.new
end


### GEM STUFF

require 'rake/gempackagetask'
spec = Gem::Specification.load 'jiraSOAP.gemspec'
Rake::GemPackageTask.new(spec) { }

desc 'Build the gem and install it'
task :install => :gem do
  require 'rubygems/dependency_installer'
  Gem::DependencyInstaller.new.install "pkg/#{spec.file_name}"
end


### TESTING

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs     << 'test'
  t.ruby_opts = ['-rhelper.rb']
  t.verbose   = true
end

desc 'Startup irb with jiraSOAP loaded'
task :console do
  sh 'irb -Ilib -rubygems -rjiraSOAP'
end


### DOCUMENTATION

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError => e
  warn 'yard not available. Install it with: gem install yard'
end
