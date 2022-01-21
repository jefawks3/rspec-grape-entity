# frozen_string_literal: true

require "spec_helper"

RSpec.describe TestEntity, type: :grape_entity do
  let(:object) do
    OpenStruct.new id: 1,
                   record_status: "active",
                   user: OpenStruct.new,
                   read: true,
                   update: false,
                   destroy: false,
                   created_at: Time.utc(2022, 1, 1, 15, 0, 0),
                   updated_at: Time.now,
                   has_date: true
  end

  it { expect(described_class).to have_root("test_items").with_singular("test_item") }

  context "when using its_exposure" do
    let(:object_without_date) { OpenStruct.new has_date: false }

    its_exposure(:id) { is_expected.to be_a_delegator_exposure }
    its_exposure(:id) { is_expected.to include_documentation type: Integer, desc: "The record id" }
    its_exposure(:id) { is_expected.not_to be_safe }
    its_exposure(:id) { is_expected.not_to be_merged }
    its_exposure(:id) { is_expected.not_to override_exposure }
    its_exposure(:record_status) { is_expected.to be_a_delegator_exposure }
    its_exposure(:record_status) { is_expected.to have_key :status }
    its_exposure(:record_status) { is_expected.to have_conditions_met(object).with_options(all: :something) }
    its_exposure(:record_status) { is_expected.to_not have_conditions_met object }
    its_exposure(:record_status) { is_expected.not_to be_safe }
    its_exposure(:record_status) { is_expected.not_to be_merged }
    its_exposure(:record_status) { is_expected.not_to override_exposure }
    its_exposure(:user) { is_expected.to be_a_represent_exposure }
    its_exposure(:user) { is_expected.to be_using_class UserEntity }
    its_exposure(:user) { is_expected.to have_conditions_met(object).with_options(type: :admin) }
    its_exposure(:user) { is_expected.not_to have_conditions_met(object).with_options(type: :user) }
    its_exposure(:user) { is_expected.not_to have_conditions_met object }
    its_exposure(:custom_data) { is_expected.to be_a_block_exposure }
    its_exposure(:custom_data) { is_expected.not_to be_safe }
    its_exposure(:custom_data) { is_expected.to be_merged }
    its_exposure(:custom_data) { is_expected.not_to override_exposure }
    its_exposure(:permissions) { is_expected.to be_a_nesting_exposure }
    its_exposure(:permissions) { is_expected.not_to be_safe }
    its_exposure(:permissions) { is_expected.not_to be_merged }
    its_exposure(:permissions) { is_expected.to override_exposure }
    its_exposure("permissions.read") { is_expected.to be_a_delegator_exposure }
    its_exposure("permissions.read") { is_expected.not_to be_safe }
    its_exposure("permissions.read") { is_expected.not_to be_merged }
    its_exposure("permissions.read") { is_expected.not_to override_exposure }
    its_exposure("permissions.update") { is_expected.to be_a_delegator_exposure }
    its_exposure("permissions.update") { is_expected.not_to be_safe }
    its_exposure("permissions.update") { is_expected.not_to be_merged }
    its_exposure("permissions.update") { is_expected.not_to override_exposure }
    its_exposure("permissions.destroy") { is_expected.to be_a_delegator_exposure }
    its_exposure("permissions.destroy") { is_expected.not_to be_safe }
    its_exposure("permissions.destroy") { is_expected.not_to be_merged }
    its_exposure("permissions.destroy") { is_expected.not_to override_exposure }
    its_exposure("created_at") { is_expected.to be_a_formatter_block_exposure }
    its_exposure("created_at") { is_expected.to have_formatting("2022-01-01T15:00:00Z").with_object(object) }
    its_exposure("created_at") { is_expected.not_to be_safe }
    its_exposure("created_at") { is_expected.not_to be_merged }
    its_exposure("created_at") { is_expected.not_to override_exposure }
    its_exposure("created_at") { is_expected.to have_conditions_met object }
    its_exposure("created_at") { is_expected.to_not have_conditions_met object_without_date }
  end

  context "when using describe_exposure" do
    shared_examples "has permissions" do |permission|
      describe_exposure "permissions.#{permission}" do
        it { is_expected.to be_a_delegator_exposure }
        it { is_expected.not_to be_safe }
        it { is_expected.not_to be_merged }
        it { is_expected.not_to override_exposure }
      end
    end

    describe_exposure :id do
      it { is_expected.to be_a_delegator_exposure }
      it { is_expected.to include_documentation type: Integer, desc: "The record id" }
      it { is_expected.not_to be_safe }
      it { is_expected.not_to be_merged }
      it { is_expected.not_to override_exposure }
    end

    describe_exposure :record_status do
      it { is_expected.to be_a_delegator_exposure }
      it { is_expected.to have_key :status }
      it { is_expected.to have_conditions_met(object).with_options(all: :something) }
      it { is_expected.to_not have_conditions_met object }
      it { is_expected.not_to be_safe }
      it { is_expected.not_to be_merged }
      it { is_expected.not_to override_exposure }
    end

    describe_exposure :user do
      it { is_expected.to be_a_represent_exposure }
      it { is_expected.to be_using_class UserEntity }

      context "when type is an admin" do
        it { is_expected.to have_conditions_met(object).with_options(type: :admin) }
      end

      context "when type is not an admin" do
        it { is_expected.not_to have_conditions_met(object).with_options(type: :user) }
      end

      context "when no type is declared" do
        it { is_expected.not_to have_conditions_met object }
      end
    end

    describe_exposure :custom_data do
      it { is_expected.to be_a_block_exposure }
      it { is_expected.not_to be_safe }
      it { is_expected.to be_merged }
      it { is_expected.not_to override_exposure }
    end

    describe_exposure :permissions do
      it { is_expected.to be_a_nesting_exposure }
      it { is_expected.not_to be_safe }
      it { is_expected.not_to be_merged }
      it { is_expected.to override_exposure }
    end

    it_behaves_like "has permissions", "read"
    it_behaves_like "has permissions", "update"
    it_behaves_like "has permissions", "destroy"

    describe_exposure :created_at do
      it { is_expected.to be_a_formatter_block_exposure }
      it { is_expected.to have_formatting("2022-01-01T15:00:00Z").with_object(object) }
      it { is_expected.not_to be_safe }
      it { is_expected.not_to be_merged }
      it { is_expected.not_to override_exposure }

      context "when has date" do
        it { is_expected.to have_conditions_met object }
      end

      context "when does not have date" do
        let(:object) { OpenStruct.new has_date: false }

        it { is_expected.not_to have_conditions_met object }
      end
    end
  end
end
