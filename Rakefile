require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "jiraSOAP"
    gem.summary = %Q{A Ruby client for the JIRA SOAP API}
    gem.description = %Q{Written to run fast and work on Ruby 1.9 as well as MacRuby}
    gem.email = "mrada@marketcircle.com"
    gem.homepage = "http://github.com/Marketcircle/jiraSOAP"
    gem.authors = ["Mark Rada"]
    gem.add_dependency 'handsoap', '~> 1.1'
    gem.add_dependency 'nokogiri', '>= 1.4.4'
    gem.add_development_dependency "minitest"
    gem.add_development_dependency "yard"
    gem.add_development_dependency "bluecloth"
    gem.add_development_dependency "jeweler"
	gem.files = ['lib/**/*']
    gem.required_ruby_version = '>= 1.9.2'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

begin
  require 'reek/rake/task'
  Reek::Rake::Task.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end


task :test => :check_dependencies

task :default => :test
begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

task :yardstick do
  begin

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

  rescue LoadError
    abort 'Yardstick is not available. In order to run yardstick, you must: sud gem install yardstick'
  end
end
