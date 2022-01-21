# frozen_string_literal: true

require "ostruct"
require "time"

require "rspec-grape-entity"

require_relative "support/user_entity"
require_relative "support/test_entity"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
