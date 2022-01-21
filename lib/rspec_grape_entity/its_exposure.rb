# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module ItsExposure
        # Creates a nested example group named by the entity exposure `attribute`,
        # and then generates an example using the submitted block.
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
        #   describe MyEntity do
        #     its_exposure(:size) { is_expected.to be_safe }
        #   end
        #
        #   # ... generates the same runtime structure as this:
        #   describe MyEntity do
        #     describe "size" do
        #       let(:entity) { described_class }
        #
        #       it "is_expected.to be_safe" do
        #         exposure = entity.find_exposure :size
        #         expect(exposure).to be_safe
        #       end
        #     end
        #   end
        #
        # The attribute can be a `Symbol` or a `String`. Given a `String`
        # with dots, the result is as though you concatenated that `String`
        # onto the entities nested exposures.
        #
        # @example
        #
        #   describe MyEntity do
        #     its_exposure("name.first_name") { should have_key :first }
        #   end
        #
        # With an implicit exposure, `is_expected` can be used as an alternative
        # to `should` (e.g. for one-liner use).
        #
        # @example
        #
        #   describe MyEntity do
        #     its_exposure(:size) { is_expected.to eq(0) }
        #   end
        def its_exposure(attribute, *options, &block)
          its_caller = caller.reject { |file_line| file_line =~ %r{/lib/rspec_grape_entity/its_exposure} }

          describe_exposure attribute, caller: its_caller do
            options << {} unless options.last.is_a?(Hash)
            options.last.merge!(caller: its_caller)

            if block
              example(nil, *options, &block)
            else
              example(nil, *options) { is_expected.not_to be_nil }
            end
          end
        end
      end
    end
  end
end
