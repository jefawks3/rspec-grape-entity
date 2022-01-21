# frozen_string_literal: true

require "grape-entity"
require "rspec/expectations"

require_relative "rspec_grape_entity/matchers/matcher_helpers"
require_relative "rspec_grape_entity/matchers/be_a_exposure_type_matcher"
require_relative "rspec_grape_entity/matchers/be_merged_matcher"
require_relative "rspec_grape_entity/matchers/be_safe_matcher"
require_relative "rspec_grape_entity/matchers/be_using_class_matcher"
require_relative "rspec_grape_entity/matchers/have_conditions_met_matcher"
require_relative "rspec_grape_entity/matchers/have_formatting_matcher"
require_relative "rspec_grape_entity/matchers/have_key_matcher"
require_relative "rspec_grape_entity/matchers/have_root_matcher"
require_relative "rspec_grape_entity/matchers/include_documentation_matcher"
require_relative "rspec_grape_entity/matchers/override_exposure_matcher"
require_relative "rspec_grape_entity/describe_exposure"
require_relative "rspec_grape_entity/its_exposure"
require_relative "rspec_grape_entity/dsl"
require_relative "rspec_grape_entity/version"

RSpec.configure do |rspec|
  rspec.extend RSpec::Grape::Entity::DescribeExposure, type: :grape_entity
  rspec.extend RSpec::Grape::Entity::ItsExposure, type: :grape_entity
  rspec.include RSpec::Grape::Entity::Matchers::HaveRootMatcher, type: :grape_entity
  rspec.backtrace_exclusion_patterns << %r{/lib/rspec_grape_entity/describe_exposure}
  rspec.backtrace_exclusion_patterns << %r{/lib/rspec_grape_entity/its_exposure}
end
