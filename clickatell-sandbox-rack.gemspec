# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clickatell/sandbox/rack/version'

Gem::Specification.new do |spec|
  spec.name          = 'clickatell-sandbox-rack'
  spec.version       = Clickatell::Sandbox::Rack::VERSION
  spec.authors       = ['Grant Petersen-Speelman']
  spec.email         = ['grantspeelman@gmail.com']

  spec.summary       = 'local sandbox clickatell environment.'
  spec.description   = 'Simple rack app the allows for a local sandbox clickatell environment.'
  spec.homepage      = 'https://github.com/grantspeelman/clickatell-sandbox-rack'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_dependency 'multi_json', '~> 1.0'

  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
