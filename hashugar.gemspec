# -*- encoding: utf-8 -*-
require File.expand_path('../lib/hashugar/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jan Suchal"]
  gem.email         = ["johno@jsmf.net"]
  gem.summary       = %q{Fast Nested OpenStruct}
  gem.description   = %q{Nested OpenStruct optimized for short-lived objects.}
  gem.homepage      = "http://github.com/jsuchal/hashugar"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "hashugar"
  gem.require_paths = ["lib"]
  gem.version       = Hashugar::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'benchmark_suite'
  gem.add_development_dependency 'ffi'
end
