# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord_with_progress/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord_with_progress"
  spec.version       = ActiverecordWithProgress::VERSION
  spec.authors       = ["Deseret Book", "Mike Bourgeous"]
  spec.email         = ["webdev@deseretbook.com", "mike@mikebourgeous.com"]

  spec.summary       = %q{Adds methods to ActiveRecord::Relation for iterating with progress bars}
  spec.homepage      = "https://github.com/deseretbook/activerecord_with_progress"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 4.1"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
