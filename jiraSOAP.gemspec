# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name    = 'jiraSOAP'
  s.version = '0.7.0'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubygems_version          = '1.5.0'
  s.required_ruby_version     = Gem::Requirement.new('~> 1.9.2')

  s.summary     = 'A Ruby client for the JIRA SOAP API'
  s.description = 'Written to run fast and work on Ruby 1.9 as well as MacRuby'
  s.authors     = ['Mark Rada']
  s.email       = ['mrada@marketcircle.com']
  s.homepage    = 'http://github.com/Marketcircle/jiraSOAP'
  s.license     = ['MIT']

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

  s.add_development_dependency 'rake',      ['~> 0.8.7']
  s.add_development_dependency 'bundler',   ['~> 1.0.10']
  s.add_development_dependency 'minitest',  ['~> 2.0.2']
  s.add_development_dependency 'reek',      ['~> 1.2.8']
  s.add_development_dependency 'yard',      ['~> 0.6.4']
  s.add_development_dependency 'bluecloth', ['~> 2.0.10']
end
