# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module BeSafeMatcher
          extend RSpec::Matchers::DSL

          matcher :be_safe do
            include MatcherHelpers

            match { |actual| exposure_attribute(actual, :is_safe) }
            description { "be safe" }
            failure_message { |actual| "expect that #{actual} to be safe" }
          end
        end
      end
    end
  end
end
