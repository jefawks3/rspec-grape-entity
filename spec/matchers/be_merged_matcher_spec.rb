# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::BeMergedMatcher do
  include RSpec::Grape::Entity::Matchers::BeMergedMatcher

  let(:entity) { TestEntity }

  context "when merged" do
    subject(:exposure) { entity.find_exposure :custom_data }
    it { is_expected.to be_merged }
  end

  context "when not merged" do
    subject(:exposure) { entity.find_exposure :id }
    it { is_expected.not_to be_merged }
  end
end
