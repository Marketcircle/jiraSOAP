require 'rubygems'

task :default => :test


### MACRUBY BONUSES

if RUBY_ENGINE == 'macruby'
  require 'rake/compiletask'
  Rake::CompileTask.new do |t|
    t.files = FileList["lib/**/*.rb"]
    t.verbose = true
  end

  desc 'Clean MacRuby binaries'
  task :clean do
    FileList["lib/**/*.rbo"].each { |bin| rm bin }
  end
end


### GEM STUFF

require 'rake/gempackagetask'
spec = Gem::Specification.load('jiraSOAP.gemspec')
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = true
end

require 'rubygems/dependency_installer'
desc 'Build the gem and install it'
task :install => :gem do
  Gem::DependencyInstaller.new.install "pkg/#{spec.file_name}"
end


### TESTING

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs     << 'test'
  t.pattern   = 'test/**/test_*.rb'
  t.ruby_opts = ['-rhelper']
  t.verbose   = true
end


### DOCUMENTATION

require 'yard'
YARD::Rake::YardocTask.new
