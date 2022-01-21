# frozen_string_literal: true

require "spec_helper"

RSpec.describe RSpec::Grape::Entity::Matchers::HaveRootMatcher do
  include RSpec::Grape::Entity::Matchers::HaveRootMatcher

  context "when root is not defined" do
    let(:described_class) do
      Class.new Grape::Entity
    end

    it { expect(described_class).to have_root(nil) }
    it { expect(described_class).to have_root(nil).with_singular(nil) }
    it { expect(described_class).not_to have_root("tests") }
    it { expect(described_class).not_to have_root("tests").with_singular(nil) }
    it { expect(described_class).not_to have_root("tests").with_singular("test") }
  end

  context "when collection root is only defined" do
    let(:described_class) do
      Class.new Grape::Entity do
        root "tests"
      end
    end

    it { expect(described_class).not_to have_root(nil) }
    it { expect(described_class).not_to have_root(nil).with_singular(nil) }
    it { expect(described_class).to have_root("tests") }
    it { expect(described_class).to have_root("tests").with_singular(nil) }
    it { expect(described_class).not_to have_root("tests").with_singular("test") }
  end

  context "when both root and collection_root is defined" do
    let(:described_class) do
      Class.new Grape::Entity do
        root "tests", "test"
      end
    end

    it { expect(described_class).not_to have_root(nil) }
    it { expect(described_class).not_to have_root(nil).with_singular(nil) }
    it { expect(described_class).not_to have_root("tests") }
    it { expect(described_class).not_to have_root("tests").with_singular(nil) }
    it { expect(described_class).to have_root("tests").with_singular("test") }
  end
end
