require 'rubygems'
require 'bundler'

# @todo add metric_fu

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = 'jiraSOAP'
  gem.summary = 'A Ruby client for the JIRA SOAP API'
  gem.description = 'Written to run fast and work on Ruby 1.9 as well as MacRuby'
  gem.email = 'mrada@marketcircle.com'
  gem.homepage = 'http://github.com/Marketcircle/jiraSOAP'
  gem.authors = ['Mark Rada']
  gem.files = ['lib/**/*']
  gem.files.include 'yard_extensions.rb'
  gem.required_ruby_version = '~> 1.9.2'
  gem.test_files = Dir.glob('test/*_test.rb')
  gem.add_dependency 'nokogiri', '~> 1.4.4'
  gem.add_dependency 'handsoap', '~> 1.1.8'
  gem.add_development_dependency 'minitest',  '~> 2.0.2'
  gem.add_development_dependency 'yard',      '~> 0.6.4'
  gem.add_development_dependency 'bluecloth', '~> 2.0.10'
  gem.add_development_dependency 'bundler',   '~> 1.0.10'
  gem.add_development_dependency 'jeweler',   '~> 1.5.2'
  gem.add_development_dependency 'reek',      '~> 1.2.8'
  gem.add_development_dependency 'rcov',      '~> 0.9.9'
  gem.test_files = Dir.glob('test/*_test.rb')
end
Jeweler::RubygemsDotOrgTasks.new

task :default => :test

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

require 'reek/rake/task'
Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

require 'yard'
require File.join(File.dirname(__FILE__),'yard_extensions')
YARD::Rake::YardocTask.new
