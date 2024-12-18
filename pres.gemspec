require "./lib/pres/version"

Gem::Specification.new do |spec|
  spec.name          = "pres"
  spec.version       = Pres::VERSION
  spec.authors       = ["Tee Parham", "Scott Jacobsen"]
  spec.email         = ["tee@neighborland.com", "scott@neighborland.com"]
  spec.summary       = "A Simple Rails Presenter"
  spec.description   = "A Simple Rails Presenter base class and controller helper"
  spec.homepage      = "https://github.com/neighborland/pres"
  spec.license       = "MIT"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files         = Dir["LICENSE.txt", "README.md", "lib/**/*"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.2.0"
end
