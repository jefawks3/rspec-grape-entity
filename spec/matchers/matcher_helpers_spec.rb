# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::MatcherHelpers do
  let(:entity) { TestEntity }
  subject(:helper) { Class.new { extend RSpec::Grape::Entity::Matchers::MatcherHelpers } }

  describe ".entity_class_name" do
    subject { helper.entity_class_name entity }

    context "when a class constant" do
      it { is_expected.to eq "TestEntity" }
    end

    context "when an instance of an entity" do
      let(:entity) { TestEntity.new(nil) }
      it { is_expected.to eq "TestEntity" }
    end
  end

  describe ".exposure_attribute" do
    let(:exposure) { entity.find_exposure :id }
    subject { helper.exposure_attribute exposure, attribute }

    context "when a valid exposure attribute" do
      let(:attribute) { :key }
      it { is_expected.to_not be_nil }
    end

    context "when an invalid exposure attribute" do
      let(:attribute) { :not_a_real_attribute }
      it { expect { subject }.to raise_error NoMethodError }
    end
  end

  describe ".exposure_type" do
    subject { helper.exposure_type exposure_type }

    context "when a block exposure" do
      let(:exposure_type) { :block }
      it { is_expected.to be Grape::Entity::Exposure::BlockExposure }
    end

    context "when a delegator exposure" do
      let(:exposure_type) { :delegator }
      it { is_expected.to be Grape::Entity::Exposure::DelegatorExposure }
    end

    context "when a formatter exposure" do
      let(:exposure_type) { :formatter }
      it { is_expected.to be Grape::Entity::Exposure::FormatterExposure }
    end

    context "when a formatter block exposure" do
      let(:exposure_type) { :formatter_block }
      it { is_expected.to be Grape::Entity::Exposure::FormatterBlockExposure }
    end

    context "when a nesting exposure" do
      let(:exposure_type) { :nesting }
      it { is_expected.to be Grape::Entity::Exposure::NestingExposure }
    end

    context "when a represent exposure" do
      let(:exposure_type) { :represent }
      it { is_expected.to be Grape::Entity::Exposure::RepresentExposure }
    end

    context "when an invalid exposure type" do
      let(:exposure_type) { :invalid_exposure_type }

      it { expect { subject }.to raise_error NameError }
    end
  end
end
