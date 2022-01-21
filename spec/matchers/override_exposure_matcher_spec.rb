# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::OverrideExposureMatcher do
  include RSpec::Grape::Entity::Matchers::OverrideExposureMatcher

  let(:entity) { TestEntity }

  context "when overriding" do
    subject(:exposure) { entity.find_exposure :permissions }
    it { is_expected.to override_exposure }
  end

  context "when not overriding" do
    subject(:exposure) { entity.find_exposure :id }
    it { is_expected.not_to override_exposure }
  end
end
