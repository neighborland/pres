# coding: utf-8
require './lib/pres/version'

Gem::Specification.new do |spec|
  spec.name          = "pres"
  spec.version       = Pres::VERSION
  spec.authors       = ["Tee Parham"]
  spec.email         = ["tee@neighborland.com"]
  spec.summary       = %(A Simple Rails Presenter)
  spec.description   = %(A Simple Rails Presenter base class and controller )
  spec.homepage      = "https://github.com/neighborland/pres"
  spec.license       = "MIT"

  spec.files         = Dir["LICENSE.txt", "README.md", "lib/**/*"]
  spec.test_files    = Dir["Gemfile", "test/**/*"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency "activesupport", "~> 4.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "minitest", "~> 5.5"
  spec.add_development_dependency "mocha", "~> 1.1"
  spec.add_development_dependency "rake", "~> 10.4"
end
