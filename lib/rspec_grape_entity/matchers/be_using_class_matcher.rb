# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module BeUsingClassMatcher
          extend RSpec::Matchers::DSL

          matcher :be_using_class do |expected|
            include MatcherHelpers

            match { |actual| expect(exposure_attribute(actual, :using_class)).to be expected }
            description { "be using entity class #{entity_class_name expected}" }
            failure_message { |actual| "expect that #{actual} would be using class #{entity_class_name expected}" }
          end
        end
      end
    end
  end
end
