# frozen_string_literal: true

class UserEntity < Grape::Entity
  format_with :iso_timestamp, &:iso8601

  expose :username
  expose :name do
    expose :first_name, as: :first, documentation: { type: String, desc: "User's last name" }
    expose :last_name, as: :last, documentation: { type: String, desc: "User's last name" }
  end
  expose :joined_at, format_with: :iso_timestamp
end
