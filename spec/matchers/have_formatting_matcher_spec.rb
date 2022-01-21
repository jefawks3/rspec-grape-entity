# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::HaveFormattingMatcher do
  include RSpec::Grape::Entity::Matchers::HaveFormattingMatcher

  let(:entity) { TestEntity }
  let(:object) do
    OpenStruct.new created_at: Time.utc(2022, 1, 22, 17, 0, 0),
                   updated_at: Time.utc(2022, 2, 4, 6, 0, 0)
  end

  context "when formatter is a symbol" do
    subject(:exposure) { entity.find_exposure :updated_at }

    it { is_expected.to have_formatting :iso_timestamp }
  end

  context "when formatter is a block" do
    subject(:exposure) { entity.find_exposure :created_at }

    it { is_expected.to have_formatting("2022-01-22T17:00:00Z").with_object(object) }
  end
end
