# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module HaveFormattingMatcher
          extend RSpec::Matchers::DSL

          matcher :have_formatting do |expected|
            include MatcherHelpers

            match do |actual|
              if actual.is_a? ::Grape::Entity::Exposure::FormatterBlockExposure
                instance = entity.new object
                actual.value(instance, {}) == expected
              else
                exposure_attribute(actual, :format_with) == expected
              end
            end

            description { "have the formatting #{expected}" }

            failure_message do |actual|
              if actual.is_a? ::Grape::Entity::Exposure::FormatterBlockExposure
                instance = entity.new object
                "expect that \"#{actual.value instance, {}}\" would have the formatting \"#{expected}\""
              else
                "expect that \"#{actual}\" would have the formatting \"#{expected}\""
              end
            end

            chain :with_object, :object
          end
        end
      end
    end
  end
end
