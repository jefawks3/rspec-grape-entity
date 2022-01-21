# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module DescribeExposure
        # Creates a group named by the entity exposure `attribute`.
        #
        # @example
        #
        #   class MyEntity < Grape::Entity
        #     expose :size, safe: true
        #     expose :name do
        #       expose :first_name, as: :first
        #       expose :last_name, as: :last
        #     end
        #   end
        #
        #   # This ...
        #   describe MyEntity, type: :entity do
        #     describe_exposure :size do
        #       ...
        #     end
        #   end
        #
        #   # ... generates the same runtime structure as this:
        #   describe MyEntity, type: :entity do
        #     describe "size" do
        #       let(:entity) { described_class }
        #       let(:exposure) { entity.find_exposure :size }
        #
        #       ...
        #     end
        #   end
        #
        # The attribute can be a `Symbol` or a `String`. Given a `String`
        # with dots, the result is as though you concatenated that `String`
        # onto the entities nested exposures.
        #
        # @example
        #
        #   describe MyEntity, type: :entity do
        #     describe_exposure "name.first_name" do
        #       ...
        #     end
        #   end
        #
        # With an implicit exposure, `is_expected` can be used as an alternative
        # to `should` (e.g. for one-liner use).
        #
        # @example
        #
        #   describe MyEntity do
        #     describe_exposure :size do
        #       it { should be_safe }
        #       it { is_expected.to be_safe }
        #     end
        #   end
        def describe_exposure(attribute, *options, &block)
          raise "Block not given" unless block_given?

          options << {} unless options.last.is_a?(Hash)
          describe_caller = options.last.fetch(:caller) do
            caller.reject { |file_line| file_line =~ %r{/lib/rspec_grape_entity/describe_exposure} }
          end

          parent_described_class = described_class

          describe attribute, caller: describe_caller do
            include RSpec::Grape::Entity::Matchers::BeAExposureTypeMatcher
            include RSpec::Grape::Entity::Matchers::BeMergedMatcher
            include RSpec::Grape::Entity::Matchers::BeSafeMatcher
            include RSpec::Grape::Entity::Matchers::BeUsingClassMatcher
            include RSpec::Grape::Entity::Matchers::HaveConditionsMetMatcher
            include RSpec::Grape::Entity::Matchers::HaveFormattingMatcher
            include RSpec::Grape::Entity::Matchers::HaveKeyMatcher
            include RSpec::Grape::Entity::Matchers::IncludeDocumentationMatcher
            include RSpec::Grape::Entity::Matchers::OverrideExposureMatcher

            let(:described_class) { parent_described_class }
            let(:entity) { described_class } unless method_defined? :entity

            let(:__attribute_exposure) do
              exposure_chain = attribute.to_s.split(".")
              exposure = entity.find_exposure exposure_chain.shift.to_sym
              exposure_chain.inject(exposure) do |inner_exposure, attr|
                inner_exposure.find_nested_exposure attr.to_sym
              end
            end

            # rubocop:disable Lint/NestedMethodDefinition
            def is_expected
              expect(__attribute_exposure)
            end

            def will(matcher = nil, message = nil)
              raise ArgumentError, "`will` only supports block expectations" unless matcher.supports_block_expectations?

              expect { __attribute_exposure }.to matcher, message
            end

            def will_not(matcher = nil, message = nil)
              unless matcher.supports_block_expectations?
                raise ArgumentError, "`will_not` only supports block expectations"
              end

              expect { __attribute_exposure }.to_not matcher, message
            end

            def should(matcher = nil, message = nil)
              RSpec::Expectations::PositiveExpectationHandler.handle_matcher(__attribute_exposure, matcher, message)
            end

            def should_not(matcher = nil, message = nil)
              RSpec::Expectations::NegativeExpectationHandler.handle_matcher(__attribute_exposure, matcher, message)
            end
            # rubocop:enable Lint/NestedMethodDefinition

            instance_eval(&block)
          end
        end
      end
    end
  end
end
