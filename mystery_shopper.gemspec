# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mystery_shopper/version"

Gem::Specification.new do |s|
  s.name = "mystery_shopper"
  s.version = MysteryShopper::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Michael Novi"]
  s.email = ["mike@sharehammer.com"]
  s.homepage = ""
  s.summary = %q{Extracts product information from ecommerce sites.}
  s.description = %q{Extracts product information from ecommerce sites.}

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'nokogiri'
  s.add_dependency 'typhoeus'
  s.add_development_dependency 'minitest-stub_any_instance'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'byebug'

  s.files = Dir.glob("{lib}/**/*")
  s.require_paths = ["lib"]
end