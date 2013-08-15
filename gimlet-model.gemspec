# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gimlet/model/version'

Gem::Specification.new do |spec|
  spec.name          = "gimlet-model"
  spec.version       = Gimlet::Model::VERSION
  spec.authors       = ["Yoji SHIDARA"]
  spec.email         = ["dara@shidara.net"]
  spec.description   = %q{Gimlet: Document-oriented, Text-based and Read-only data storage, acts as Model}
  spec.summary       = %q{Gimlet: Document-oriented, Text-based and Read-only data storage, acts as Model}
  spec.homepage      = "https://github.com/darashi/gimlet-model"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "gimlet", "~> 0.0.3"
end
