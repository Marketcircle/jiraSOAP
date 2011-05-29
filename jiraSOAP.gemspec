$LOAD_PATH.unshift File.join( File.dirname(__FILE__), 'lib')
require 'jiraSOAP/version'

Gem::Specification.new do |s|
  s.name    = 'jiraSOAP'
  s.version = JIRA::VERSION

  s.summary     = 'A Ruby client for the JIRA SOAP API'
  s.description = 'Written to run fast and work on Ruby 1.9 as well as MacRuby'
  s.authors     = ['Mark Rada']
  s.email       = ['mrada@marketcircle.com']
  s.homepage    = 'http://github.com/Marketcircle/jiraSOAP'
  s.license     = 'MIT'

  s.require_paths    = ['lib']
  s.files            = Dir.glob('lib/**/*.rb')
  s.test_files       = Dir.glob('test/**/*')
  s.extra_rdoc_files = [
                        'Rakefile',
                        'ChangeLog',
                        'LICENSE.txt',
                        'README.markdown',
                        '.yardopts',
                        'docs/GettingStarted.markdown',
                        'yard-jiraSOAP.rb'
                       ]

  s.add_runtime_dependency 'nokogiri', ['~> 1.4.4']
  s.add_runtime_dependency 'handsoap', ['~> 1.1.8']

  s.add_development_dependency 'yard',      ['~> 0.6.8']
  s.add_development_dependency 'rdiscount', ['~> 1.6.8']
  s.add_development_dependency 'yardstick', ['~> 0.3.0']
  if RUBY_ENGINE == 'macruby'
    s.add_development_dependency 'minitest-macruby-pride',  ['~> 2.2.0']
  elsif RUBY_VERSION == '1.9.2'
    s.add_development_dependency 'minitest',                ['~> 2.1.0']
  end
end
