source "https://rubygems.org"

if ENV["TRAVIS"]
  gem "coveralls", require: false
end

if ENV["BYEBUG"]
  gem "byebug"
end

if RUBY_VERSION < "2.2.2"
  gem "activesupport", "~> 4.2"
end

gemspec
