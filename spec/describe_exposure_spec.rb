# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::DescribeExposure do
  extend RSpec::Grape::Entity::DescribeExposure

  let(:entity) { TestEntity }

  describe_exposure :id do
    it { is_expected.to be_a Grape::Entity::Exposure::DelegatorExposure }
  end

  describe_exposure "id" do
    it { is_expected.to be_a Grape::Entity::Exposure::DelegatorExposure }
  end

  describe_exposure "unknown" do
    it { is_expected.to be_nil }
  end

  describe_exposure "permissions.read" do
    it { is_expected.to be_a Grape::Entity::Exposure::DelegatorExposure }
  end

  describe_exposure "unknown.unknown" do
    it { expect { __attribute_exposure }.to raise_error NoMethodError }
  end
end