# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rspec_grape_entity/version"

Gem::Specification.new do |spec|
  spec.name = "rspec-grape-entity"
  spec.version = RSpecGrapeEntity::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["James Fawks"]
  spec.email = ["jefawks3@gmail.com"]
  spec.summary = "RSpec extension gem for grape-entity"
  spec.description = 'Provides "it_exposes" and "describe_exposure" methods to test Grape Entities'
  spec.homepage = "https://github.com/jefawks3/rspec-grape-entity"
  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/jefawks3/rspec-grape-entity/issues",
    "changelog_uri" => "https://github.com/jefawks3/rspec-grape-entity/releases",
    "documentation_uri" => "https://github.com/jefawks3/rspec-grape-entity",
    "source_code_uri" => "https://github.com/jefawks3/rspec-grape-entity"
  }

  spec.required_ruby_version = ">= 2.7.0"

  spec.add_runtime_dependency "grape-entity", ">= 0.10.0"
  spec.add_runtime_dependency "rspec-core", ">= 3.0.0"
  spec.add_runtime_dependency "rspec-expectations", ">= 3.0.0"

  spec.add_development_dependency "bundler",  "> 1.3.0"
  spec.add_development_dependency "rake",     "~> 13.0.0"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec}/*`.split("\n")
  spec.require_paths = ["lib"]
end
