# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module IncludeDocumentationMatcher
          extend RSpec::Matchers::DSL

          matcher :include_documentation do |expected|
            include MatcherHelpers

            match { |actual| expect(documentation(actual)).to include expected }
            match_when_negated { |actual| expect(documentation(actual)).to_not include expected }
            description { "include documentation #{expected}" }
            failure_message { |actual| "expect #{documentation actual} would include the documentation #{expected}" }

            def documentation(actual)
              exposure_attribute(actual, :documentation) || {}
            end
          end
        end
      end
    end
  end
end
