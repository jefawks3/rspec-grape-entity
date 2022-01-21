# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module HaveKeyMatcher
          extend RSpec::Matchers::DSL

          matcher :have_key do |expected|
            include MatcherHelpers

            match { |actual| exposure_attribute(actual, :key) == expected }
            description { "have the key #{expected}" }
            failure_message { |actual| "expect that #{actual} would have the key #{expected}" }
          end
        end
      end
    end
  end
end
