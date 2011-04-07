require 'rubygems'
require 'rake'

task :default => :test

if RUBY_ENGINE == 'macruby'
  namespace :macruby do

    require 'rake/compiletask'
    Rake::CompileTask.new do |t|
      t.files = FileList["lib/**/*.rb"]
      t.verbose = true
    end

    desc 'Clean MacRuby binaries'
    task :clean do
      FileList["lib/**/*.rbo"].each do |bin|
        puts "Removing #{bin}"
        rm bin
      end
    end

  end
end


require 'rubygems/builder'
require 'rubygems/installer'
spec = Gem::Specification.load('jiraSOAP.gemspec')

desc 'Build the gem'
task :build do Gem::Builder.new(spec).build end

desc 'Build the gem and install it'
task :install => :build do Gem::Installer.new(spec.file_name).install end


require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end


require 'yard'
YARD::Rake::YardocTask.new

require 'yardstick/rake/measurement'
Yardstick::Rake::Measurement.new(:yardstick_measure) do |measurement|
  measurement.output = 'measurement/report.txt'
end

require 'yardstick/rake/verify'
Yardstick::Rake::Verify.new do |verify|
  verify.threshold = 100
end
