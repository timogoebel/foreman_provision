# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foreman_provision/version'

Gem::Specification.new do |spec|
  spec.name          = 'foreman_provision'
  spec.version       = ForemanProvision::VERSION
  spec.authors       = ['Nils Domrose']
  spec.email         = ['nils.domrose@inovex.de']
  spec.description   = 'Gem to provision hosts on theforeman'
  spec.summary       = 'This gem support provisioning of hosts using foremans REST API version 2'
  spec.homepage      = 'http://www.inovex.de'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_dependency 'foreman_api'
end
