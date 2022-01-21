# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::IncludeDocumentationMatcher do
  include RSpec::Grape::Entity::Matchers::IncludeDocumentationMatcher

  let(:entity) { TestEntity }

  context "when has documentation" do
    subject(:exposure) { entity.find_exposure :id }

    it { is_expected.to include_documentation type: Integer, desc: "The record id" }
    it { is_expected.to include_documentation type: Integer }
    it { is_expected.to include_documentation desc: "The record id" }
    it { is_expected.to include_documentation :type, :desc }
    it { is_expected.to include_documentation :desc }
    it { is_expected.to include_documentation :type }
  end

  context "when does not have documentation" do
    subject(:exposure) { entity.find_exposure :permissions }

    it { is_expected.not_to include_documentation type: Integer, desc: "Permissions" }
    it { is_expected.not_to include_documentation type: Integer }
    it { is_expected.not_to include_documentation desc: "The record id" }
    it { is_expected.not_to include_documentation :type, :desc }
    it { is_expected.not_to include_documentation :desc }
    it { is_expected.not_to include_documentation :type }
  end
end
