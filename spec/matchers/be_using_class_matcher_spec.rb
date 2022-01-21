# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::BeUsingClassMatcher do
  include RSpec::Grape::Entity::Matchers::BeUsingClassMatcher

  let(:entity) { TestEntity }

  context "when using a represent entity" do
    subject(:exposure) { entity.find_exposure :user }
    it { is_expected.to be_using_class UserEntity }
    it { is_expected.not_to be_using_class TestEntity }
  end
end
