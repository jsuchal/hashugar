# -*- encoding: utf-8 -*-
require_relative 'lib/hashugar/version'

Gem::Specification.new do |gem|
  gem.authors       = ['Jan Suchal', 'Stephen Benner']
  gem.email         = 'sbenner9@gmail.com'
  gem.summary       = 'Fast nested OpenStruct'
  gem.description   = 'Nested OpenStruct optimized for short-lived objects.'
  gem.homepage      = 'https://github.com/SteveBenner/hashugar'
  gem.license       = 'MIT'

  gem.executables   = `git ls-files -- bin/*`.split($/).map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split $/
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split $/
  gem.name          = 'hashugar'
  gem.require_paths = ['lib']
  gem.version       = Hashugar::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'benchmark_suite'
  gem.add_development_dependency 'ffi'
  gem.add_development_dependency 'hashr'
end
