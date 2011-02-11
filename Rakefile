require 'rubygems'
require 'bundler'

begin
  Bundler.setup :default, :development
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'

task :default => :test


namespace :macruby do
  desc 'AOT compile for MacRuby'
  task :compile do
    FileList["lib/**/*.rb"].each do |source|
      name = File.basename source
      puts "#{name} => #{name}o"
      `macrubyc --framework Foundation --arch x86_64 -C '#{source}' -o '#{source}o'`
    end
  end

  desc 'Clean MacRuby binaries'
  task :clean do
    FileList["lib/**/*.rbo"].each do |bin|
      rm bin
    end
  end
end


desc 'Build the gem'
task :build do
  puts `gem build -v jiraSOAP.gemspec`
end

desc 'Install the gem in the current directory with the highest version number'
task :install => :build do
  puts `gem install #{Dir.glob('*.gem').sort.reverse.first}`
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs   << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

require 'reek/rake/task'
Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose       = false
  t.source_files  = 'lib/**/*.rb'
end

require 'yard'
require File.join(File.dirname(__FILE__),'yard_extensions')
YARD::Rake::YardocTask.new
