# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module HaveConditionsMetMatcher
          extend RSpec::Matchers::DSL

          matcher :have_conditions_met do |object|
            include MatcherHelpers

            match do |actual|
              entity_instance = entity.new object
              actual.conditions_met? entity_instance, options
            end

            description { "have the conditions met" }

            failure_message do |actual|
              "expect that #{actual} would have the conditions met for object #{object} with options #{options}"
            end

            chain :with_options do |options|
              @options = options
            end

            def options
              @options ||= {}
            end
          end
        end
      end
    end
  end
end
