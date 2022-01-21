# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::BeSafeMatcher do
  include RSpec::Grape::Entity::Matchers::BeSafeMatcher

  let(:entity) { TestEntity }

  context "when safe" do
    subject(:exposure) { entity.find_exposure :user }
    it { is_expected.to be_safe }
  end

  context "when not safe" do
    subject(:exposure) { entity.find_exposure :id }
    it { is_expected.not_to be_safe }
  end
end
