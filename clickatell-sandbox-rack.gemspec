# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clickatell/catcher/rack/version'

Gem::Specification.new do |spec|
  spec.name          = 'clickatell-catcher-rack'
  spec.version       = Clickatell::Catcher::Rack::VERSION
  spec.authors       = ['Grant Petersen-Speelman']
  spec.email         = ['grantspeelman@gmail.com']

  spec.summary       = 'local sms catcher clickatell environment.'
  spec.description   = 'Simple rack app the allows for a local catcher clickatell environment.'
  spec.homepage      = 'https://github.com/grantspeelman/clickatell-catcher-rack'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'rack', '>= 1.1.0', '< 3.0'
  spec.add_dependency 'multi_json', '>= 1.3.0', '~> 1.0'

  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rubocop', '~> 0.46.0'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
