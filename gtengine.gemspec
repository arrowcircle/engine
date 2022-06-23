# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gtengine/version'

Gem::Specification.new do |spec|
  spec.name          = "gtengine"
  spec.version       = Gtengine::VERSION
  spec.authors       = ["Oleg Bovykin"]
  spec.email         = ["oleg.bovykin@gmail.com"]
  spec.description   = %q{Gas Turbine engine and its components math models written in ruby}
  spec.summary       = %q{Gas Turbine engine and its components math models written in ruby}
  spec.homepage      = "https://github.com/arrowcircle/engine"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
end
