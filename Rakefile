require 'rubygems'
require 'bundler'
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
  gem.name = "jiraSOAP"
  gem.summary = %Q{A Ruby client for the JIRA SOAP API}
  gem.description = %Q{Written to run fast and work on Ruby 1.9 as well as MacRuby}
  gem.email = "mrada@marketcircle.com"
  gem.homepage = "http://github.com/Marketcircle/jiraSOAP"
  gem.authors = ["Mark Rada"]
  gem.add_dependency 'handsoap', '~> 1.1'
  gem.add_dependency 'nokogiri', '~> 1.4.4'
  gem.add_development_dependency 'minitest', '~> 2.0'
  gem.add_development_dependency 'yard', '~> 0.6.0'
  gem.add_development_dependency 'bluecloth', '~> 2.0.0'
  gem.add_development_dependency 'jeweler', '~> 1.5.0'
  gem.files = ['lib/**/*']
  gem.required_ruby_version = '~> 1.9.2'
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

require 'yard'
YARD::Rake::YardocTask.new

task :yardstick do
  # measure
  require 'yardstick/rake/measurement'
  Yardstick::Rake::Measurement.new(:yardstick_measure) do |measurement|
    measurement.output = 'measurement/report.txt'
  end

  # verify
  require 'yardstick/rake/verify'
  Yardstick::Rake::Verify.new do |verify|
    verify.threshold = 100
  end
end
