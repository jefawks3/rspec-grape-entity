# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::HaveConditionsMetMatcher do
  include RSpec::Grape::Entity::Matchers::HaveConditionsMetMatcher

  let(:entity) { TestEntity }
  let(:object) { OpenStruct.new has_date: true }

  context "when condition a symbol" do
    subject(:exposure) { entity.find_exposure :record_status }

    it { is_expected.to have_conditions_met(object).with_options(all: true) }
    it { is_expected.to_not have_conditions_met(object) }
  end

  context "when condition a hash" do
    subject(:exposure) { entity.find_exposure :user }

    it { is_expected.to have_conditions_met(object).with_options(type: :admin) }
    it { is_expected.to_not have_conditions_met(object).with_options(type: :user) }
    it { is_expected.to_not have_conditions_met(object) }
  end

  context "when condition a proc" do
    subject(:exposure) { entity.find_exposure :created_at }

    let(:false_object) { OpenStruct.new date: false }

    it { is_expected.to have_conditions_met(object) }
    it { is_expected.not_to have_conditions_met(false_object) }
  end

  context "when no conditions defined" do
    subject(:exposure) { entity.find_exposure :id }

    it { is_expected.to have_conditions_met(object) }
  end
end
