# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module BeAExposureTypeMatcher
          extend RSpec::Matchers::DSL

          EXPOSURE_TYPES = %i[block delegator formatter_block formatter nesting represent].freeze

          matcher :be_a_exposure_type do |expected|
            include MatcherHelpers

            match { |actual| actual.is_a? exposure_type(expected) }
            description { "be exposure type #{expected}" }
            failure_message { |actual| "expect that #{actual} to be a #{expected} exposure" }
          end

          EXPOSURE_TYPES.each do |type|
            matcher :"be_a_#{type}_exposure" do
              include MatcherHelpers

              match { |actual| actual.is_a? exposure_type(type) }
              description { "be a #{type} exposure" }
              failure_message { |actual| "expect that #{actual} to be a #{type} exposure" }
            end
          end
        end
      end
    end
  end
end
