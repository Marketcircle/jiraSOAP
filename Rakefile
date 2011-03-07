require 'rubygems'
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
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'yard'
YARD::Rake::YardocTask.new
