# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module HaveRootMatcher
          extend RSpec::Matchers::DSL

          matcher :have_root do |plural|
            include MatcherHelpers

            match do |actual|
              actual_plural = actual.root_element :collection_root
              actual_singular = actual.root_element :root

              values_match?(plural, actual_plural) &&
                values_match?(singular, actual_singular)
            end

            description { "have the formatting #{expected}" }

            failure_message do |actual|
              "expect that \"#{actual}\" would have the root collection \"#{plural}\" and root \"#{singular}\""
            end

            chain :with_singular, :singular
          end
        end
      end
    end
  end
end
