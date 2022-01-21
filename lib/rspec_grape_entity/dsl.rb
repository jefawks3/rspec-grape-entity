# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module DSL
        def self.included(klass)
          klass.class_eval do
            extend DescribeExposure
            extend ItsExposure
          end
        end
      end
    end
  end
end
