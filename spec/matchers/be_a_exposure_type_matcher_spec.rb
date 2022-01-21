# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::BeAExposureTypeMatcher do
  include RSpec::Grape::Entity::Matchers::BeAExposureTypeMatcher

  let(:entity) { TestEntity }
  subject(:exposure) { entity.find_exposure attribute }

  context "when a block exposure" do
    let(:attribute) { :custom_data }
    it { is_expected.to be_a_exposure_type :block }
    it { is_expected.not_to be_a_exposure_type :delegator }
    it { is_expected.not_to be_a_exposure_type :formatter }
    it { is_expected.not_to be_a_exposure_type :formatter_block }
    it { is_expected.not_to be_a_exposure_type :nesting }
    it { is_expected.not_to be_a_exposure_type :represent }
    it { is_expected.to be_a_block_exposure }
    it { is_expected.not_to be_a_delegator_exposure }
    it { is_expected.not_to be_a_formatter_exposure }
    it { is_expected.not_to be_a_formatter_block_exposure }
    it { is_expected.not_to be_a_nesting_exposure }
    it { is_expected.not_to be_a_represent_exposure }
  end

  context "when a delegator exposure" do
    let(:attribute) { :id }
    it { is_expected.not_to be_a_exposure_type :block }
    it { is_expected.to be_a_exposure_type :delegator }
    it { is_expected.not_to be_a_exposure_type :formatter }
    it { is_expected.not_to be_a_exposure_type :formatter_block }
    it { is_expected.not_to be_a_exposure_type :nesting }
    it { is_expected.not_to be_a_exposure_type :represent }
    it { is_expected.not_to be_a_block_exposure }
    it { is_expected.to be_a_delegator_exposure }
    it { is_expected.not_to be_a_formatter_exposure }
    it { is_expected.not_to be_a_formatter_block_exposure }
    it { is_expected.not_to be_a_nesting_exposure }
    it { is_expected.not_to be_a_represent_exposure }
  end

  context "when a formatter exposure" do
    let(:attribute) { :updated_at }
    it { is_expected.not_to be_a_exposure_type :block }
    it { is_expected.not_to be_a_exposure_type :delegator }
    it { is_expected.to be_a_exposure_type :formatter }
    it { is_expected.not_to be_a_exposure_type :formatter_block }
    it { is_expected.not_to be_a_exposure_type :nesting }
    it { is_expected.not_to be_a_exposure_type :represent }
    it { is_expected.not_to be_a_block_exposure }
    it { is_expected.not_to be_a_delegator_exposure }
    it { is_expected.to be_a_formatter_exposure }
    it { is_expected.not_to be_a_formatter_block_exposure }
    it { is_expected.not_to be_a_nesting_exposure }
    it { is_expected.not_to be_a_represent_exposure }
  end

  context "when a formatter block exposure" do
    let(:attribute) { :created_at }
    it { is_expected.not_to be_a_exposure_type :block }
    it { is_expected.not_to be_a_exposure_type :delegator }
    it { is_expected.not_to be_a_exposure_type :formatter }
    it { is_expected.to be_a_exposure_type :formatter_block }
    it { is_expected.not_to be_a_exposure_type :nesting }
    it { is_expected.not_to be_a_exposure_type :represent }
    it { is_expected.not_to be_a_block_exposure }
    it { is_expected.not_to be_a_delegator_exposure }
    it { is_expected.not_to be_a_formatter_exposure }
    it { is_expected.to be_a_formatter_block_exposure }
    it { is_expected.not_to be_a_nesting_exposure }
    it { is_expected.not_to be_a_represent_exposure }
  end

  context "when a nesting exposure" do
    let(:attribute) { :permissions }
    it { is_expected.not_to be_a_exposure_type :block }
    it { is_expected.not_to be_a_exposure_type :delegator }
    it { is_expected.not_to be_a_exposure_type :formatter }
    it { is_expected.not_to be_a_exposure_type :formatter_block }
    it { is_expected.to be_a_exposure_type :nesting }
    it { is_expected.not_to be_a_exposure_type :represent }
    it { is_expected.not_to be_a_block_exposure }
    it { is_expected.not_to be_a_delegator_exposure }
    it { is_expected.not_to be_a_formatter_exposure }
    it { is_expected.not_to be_a_formatter_block_exposure }
    it { is_expected.to be_a_nesting_exposure }
    it { is_expected.not_to be_a_represent_exposure }
  end

  context "when a represent exposure" do
    let(:attribute) { :user }
    it { is_expected.not_to be_a_exposure_type :block }
    it { is_expected.not_to be_a_exposure_type :delegator }
    it { is_expected.not_to be_a_exposure_type :formatter }
    it { is_expected.not_to be_a_exposure_type :formatter_block }
    it { is_expected.not_to be_a_exposure_type :nesting }
    it { is_expected.to be_a_exposure_type :represent }
    it { is_expected.not_to be_a_block_exposure }
    it { is_expected.not_to be_a_delegator_exposure }
    it { is_expected.not_to be_a_formatter_exposure }
    it { is_expected.not_to be_a_formatter_block_exposure }
    it { is_expected.not_to be_a_nesting_exposure }
    it { is_expected.to be_a_represent_exposure }
  end
end
