# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module OverrideExposureMatcher
          extend RSpec::Matchers::DSL

          matcher :override_exposure do
            include MatcherHelpers

            match { |actual| exposure_attribute(actual, :override) }
            description { "override exposure" }
            failure_message { |actual| "expect that #{actual} would override exposure" }
          end
        end
      end
    end
  end
end
