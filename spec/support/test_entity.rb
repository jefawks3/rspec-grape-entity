# frozen_string_literal: true

class TestEntity < Grape::Entity
  root "test_items", "test_item"

  format_with :iso_timestamp, &:iso8601

  expose :id, documentation: { type: Integer, desc: "The record id" }
  expose :record_status, as: :status, if: :all
  expose :user, safe: true, using: UserEntity, if: { type: :admin }
  expose :custom_data, merge: true do |_, _|
    {
      foo: :bar
    }
  end
  expose :permissions, override: true do
    expose :read
    expose :update
    expose :destroy
  end
  expose :created_at, format_with: ->(date) { date.iso8601 }, if: ->(instance, _) { instance.has_date }
  expose :updated_at, format_with: :iso_timestamp
end
