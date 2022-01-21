# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::ItsExposure do
  include RSpec::Grape::Entity::DSL

  let(:entity) { TestEntity }

  its_exposure(:id)
  its_exposure("id")
  its_exposure(:id) { is_expected.to be_a Grape::Entity::Exposure::DelegatorExposure }
  its_exposure(:unknown) { is_expected.to be_nil }
  its_exposure("permissions.read") { is_expected.to be_a Grape::Entity::Exposure::DelegatorExposure }
  its_exposure("unknown.unknown") { expect { __attribute_exposure }.to raise_error NoMethodError }
end