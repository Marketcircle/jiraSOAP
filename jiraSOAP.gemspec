require './lib/jiraSOAP/version'

Gem::Specification.new do |s|
  s.name    = 'jiraSOAP'
  s.version = JIRA::VERSION

  s.summary     = 'A Ruby client for the JIRA SOAP API'
  s.description = 'Written to run fast and work on Ruby 1.9 as well as MacRuby'
  s.authors     = ['Mark Rada']
  s.email       = ['markrada26@gmail.com']
  s.homepage    = 'http://github.com/Marketcircle/jiraSOAP'
  s.license     = 'MIT'

  s.files            = Dir.glob('lib/**/*.rb') + ['.yardopts', 'Rakefile']
  s.test_files       = Dir.glob('test/**/*')
  s.extra_rdoc_files = [
                        'README.markdown',
                        'ChangeLog',
                        'LICENSE.txt',
                        'docs/GettingStarted.markdown',
                        'docs/Examples.markdown'
                       ]

  s.add_runtime_dependency 'nokogiri',   '~> 1.5'
  s.add_runtime_dependency 'handsoap',   '~> 1.1.8'
#  s.add_runtime_dependency 'httpclient', '~> 2.2.1'

  s.add_development_dependency 'yard',      '~> 0.8.2'
  s.add_development_dependency 'redcarpet', '~> 1.17'
  s.add_development_dependency 'minitest',  '~> 3.1'
end
