# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::HaveKeyMatcher do
  include RSpec::Grape::Entity::Matchers::HaveKeyMatcher

  let(:entity) { TestEntity }

  context "when alias is not defined" do
    subject(:exposure) { entity.find_exposure :id }

    it { is_expected.to have_key :id }
    it { is_expected.not_to have_key :external_id }
  end

  context "when alias is defined" do
    subject(:exposure) { entity.find_exposure :record_status }

    it { is_expected.to have_key :status }
    it { is_expected.not_to have_key :record_status }
  end
end
