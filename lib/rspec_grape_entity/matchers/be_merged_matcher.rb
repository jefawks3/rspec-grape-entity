# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module BeMergedMatcher
          extend RSpec::Matchers::DSL

          matcher :be_merged do
            include MatcherHelpers

            match { |actual| exposure_attribute(actual, :for_merge) }
            description { "be merged" }
            failure_message { |actual| "expect that #{actual} would merge contents" }
          end
        end
      end
    end
  end
end
