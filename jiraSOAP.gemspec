Gem::Specification.new do |s|
  s.name    = 'jiraSOAP'
  s.version = '0.7.2'

  s.required_ruby_version = Gem::Requirement.new('~> 1.9.2')

  s.summary     = 'A Ruby client for the JIRA SOAP API'
  s.description = 'Written to run fast and work on Ruby 1.9 as well as MacRuby'
  s.authors     = ['Mark Rada']
  s.email       = ['mrada@marketcircle.com']
  s.homepage    = 'http://github.com/Marketcircle/jiraSOAP'
  s.license     = ['MIT']
  s.has_rdoc    = 'yard'

  s.require_paths    = ['lib']
  s.files            = Dir.glob('lib/**/*.rb') + ['yard-jiraSOAP.rb']
  s.test_files       = Dir.glob('test/**/*')
  s.extra_rdoc_files = [
                        'ChangeLog',
                        'LICENSE.txt',
                        'README.markdown',
                        '.yardopts'
                       ]

  s.add_runtime_dependency 'nokogiri', ['~> 1.4.4']
  s.add_runtime_dependency 'handsoap', ['~> 1.1.8']

  s.add_development_dependency 'minitest',  ['~> 2.2.2']
  s.add_development_dependency 'yard',      ['~> 0.7.1']
  s.add_development_dependency 'redcarpet', ['~> 1.15']
end
