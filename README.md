# Table of Contents

- [Rspec::Grape::Entity](#rspecgrapeentity)
  - [Introduction](#introduction)
  - [Installation](#installation)
  - [Include Rspec::Grape::Entity](#include-rspecgrapeentity)
  - [Usage](#usage)
  - [Example](#example)
  - [Entity Matchers](#entity-matchers)
    - [`root`](#have_rootplural)
  - [Exposure Matchers](#exposure-matchers)
    - [`be_a_block_exposure`](#be_a_block_exposure)
    - [`be_a_delegator_exposure`](#be_a_delegator_exposure)
    - [`be_a_formatter_exposure`](#be_a_formatter_exposure)
    - [`be_a_formatter_block_exposure`](#be_a_formatter_block_exposure)
    - [`be_a_nesting_exposure`](#be_a_nesting_exposure)
    - [`be_a_represent_exposure`](#be_a_represent_exposure)
    - [`be_merged`](#be_merged)
    - [`be_safe`](#be_safe)
    - [`be_using_class`](#be_using_classentity)
    - [`have_conditions_met`](#have_conditions_metobject)
    - [`have_formatting`](#have_formattingformatter)
    - [`have_key`](#have_keykey)
    - [`include_documentation`](#include_documentationdocs)
    - [`override_exposure`](#override_exposure)
  - [Development](#development)
  - [Report Issues](#report-issues)
  - [License](#license)

# Rspec::Grape::Entity

## Introduction

This gem, inspired by [rspec-its](https://github.com/rspec/rspec-its), provides the `its_exposure` and `describe_exposure` 
short-hand to specify the expected configuration of a given [GrapeEntity](https://github.com/ruby-grape/grape-entity) 
exposure.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-grape-entity', group: :test
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rspec-grape-entity

## Include `RSpec::Grape::Entity`

Include the `RSpec::Grape::Entity` matchers automatically by defining the described `type` as `:grape_entity` or by 
including the `RSpec::Grape::Entity::DSL` directly.

```ruby
# Automatic
describe MyEntity, type: :grape_entity do
  # ... tests
end

# Manually
describe MyEntity do
  include RSpec::Grape::Entity::DSL
  
  # ... tests
end
```

## Usage

Use the `describe_exposure` or `its_exposure` methods to generate a nested example group that specifies the expected 
exposure of an attribute of the entity using `should`, `should_not` or `is_expected`.

`describe_exposure` and `its_exposure` accepts a symbol or string.

```ruby
describe_exposure :id do
  #...
end

describe_exposure 'id' do
  #...
end

its_exposure(:id) { is_expected.not_to be_nil }
its_exposure('id') { is_expected.not_to be_nil }
```

You can use a string with dots to specify a nested exposure attribute.

```ruby
describe_exposure 'status.value' do
  #...
end

describe_exposure 'status.changed_at' do
  #...
end

its_exposure('status.value') { is_expected.not_to be_nil }
its_exposure('status.changed_at') { is_expected.not_to be_nil }
```

## Example

```ruby
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

RSpec.describe TestEntity, type: :grape_entity do
  let(:object) do
    OpenStruct.new id: 1,
                   record_status: "active",
                   user: OpenStruct.new,
                   read: true,
                   update: false,
                   destroy: false,
                   created_at: Time.utc(2022, 1, 1, 15, 0, 0),
                   updated_at: Time.now,
                   has_date: true
  end

  it { expect(described_class).to have_root("test_items").with_singular("test_item") }

  context "when using its_exposure" do
    let(:object_without_date) { OpenStruct.new has_date: false }

    its_exposure(:id) { is_expected.to be_a_delegator_exposure }
    its_exposure(:id) { is_expected.to include_documentation type: Integer, desc: "The record id" }
    its_exposure(:id) { is_expected.not_to be_safe }
    its_exposure(:id) { is_expected.not_to be_merged }
    its_exposure(:id) { is_expected.not_to override_exposure }
    its_exposure(:record_status) { is_expected.to be_a_delegator_exposure }
    its_exposure(:record_status) { is_expected.to have_key :status }
    its_exposure(:record_status) { is_expected.to have_conditions_met(object).with_options(all: :something) }
    its_exposure(:record_status) { is_expected.to_not have_conditions_met object }
    its_exposure(:record_status) { is_expected.not_to be_safe }
    its_exposure(:record_status) { is_expected.not_to be_merged }
    its_exposure(:record_status) { is_expected.not_to override_exposure }
    its_exposure(:user) { is_expected.to be_a_represent_exposure }
    its_exposure(:user) { is_expected.to be_using_class UserEntity }
    its_exposure(:user) { is_expected.to have_conditions_met(object).with_options(type: :admin) }
    its_exposure(:user) { is_expected.not_to have_conditions_met(object).with_options(type: :user) }
    its_exposure(:user) { is_expected.not_to have_conditions_met object }
    its_exposure(:custom_data) { is_expected.to be_a_block_exposure }
    its_exposure(:custom_data) { is_expected.not_to be_safe }
    its_exposure(:custom_data) { is_expected.to be_merged }
    its_exposure(:custom_data) { is_expected.not_to override_exposure }
    its_exposure(:permissions) { is_expected.to be_a_nesting_exposure }
    its_exposure(:permissions) { is_expected.not_to be_safe }
    its_exposure(:permissions) { is_expected.not_to be_merged }
    its_exposure(:permissions) { is_expected.to override_exposure }
    its_exposure("permissions.read") { is_expected.to be_a_delegator_exposure }
    its_exposure("permissions.read") { is_expected.not_to be_safe }
    its_exposure("permissions.read") { is_expected.not_to be_merged }
    its_exposure("permissions.read") { is_expected.not_to override_exposure }
    its_exposure("permissions.update") { is_expected.to be_a_delegator_exposure }
    its_exposure("permissions.update") { is_expected.not_to be_safe }
    its_exposure("permissions.update") { is_expected.not_to be_merged }
    its_exposure("permissions.update") { is_expected.not_to override_exposure }
    its_exposure("permissions.destroy") { is_expected.to be_a_delegator_exposure }
    its_exposure("permissions.destroy") { is_expected.not_to be_safe }
    its_exposure("permissions.destroy") { is_expected.not_to be_merged }
    its_exposure("permissions.destroy") { is_expected.not_to override_exposure }
    its_exposure("created_at") { is_expected.to be_a_formatter_block_exposure }
    its_exposure("created_at") { is_expected.to have_formatting("2022-01-01T15:00:00Z").with_object(object) }
    its_exposure("created_at") { is_expected.not_to be_safe }
    its_exposure("created_at") { is_expected.not_to be_merged }
    its_exposure("created_at") { is_expected.not_to override_exposure }
    its_exposure("created_at") { is_expected.to have_conditions_met object }
    its_exposure("created_at") { is_expected.to_not have_conditions_met object_without_date }
  end

  context "when using describe_exposure" do
    shared_examples "has permissions" do |permission|
      describe_exposure "permissions.#{permission}" do
        it { is_expected.to be_a_delegator_exposure }
        it { is_expected.not_to be_safe }
        it { is_expected.not_to be_merged }
        it { is_expected.not_to override_exposure }
      end
    end

    describe_exposure :id do
      it { is_expected.to be_a_delegator_exposure }
      it { is_expected.to include_documentation type: Integer, desc: "The record id" }
      it { is_expected.not_to be_safe }
      it { is_expected.not_to be_merged }
      it { is_expected.not_to override_exposure }
    end

    describe_exposure :record_status do
      it { is_expected.to be_a_delegator_exposure }
      it { is_expected.to have_key :status }
      it { is_expected.to have_conditions_met(object).with_options(all: :something) }
      it { is_expected.to_not have_conditions_met object }
      it { is_expected.not_to be_safe }
      it { is_expected.not_to be_merged }
      it { is_expected.not_to override_exposure }
    end

    describe_exposure :user do
      it { is_expected.to be_a_represent_exposure }
      it { is_expected.to be_using_class UserEntity }

      context "when type is an admin" do
        it { is_expected.to have_conditions_met(object).with_options(type: :admin) }
      end

      context "when type is not an admin" do
        it { is_expected.not_to have_conditions_met(object).with_options(type: :user) }
      end

      context "when no type is declared" do
        it { is_expected.not_to have_conditions_met object }
      end
    end

    describe_exposure :custom_data do
      it { is_expected.to be_a_block_exposure }
      it { is_expected.not_to be_safe }
      it { is_expected.to be_merged }
      it { is_expected.not_to override_exposure }
    end

    describe_exposure :permissions do
      it { is_expected.to be_a_nesting_exposure }
      it { is_expected.not_to be_safe }
      it { is_expected.not_to be_merged }
      it { is_expected.to override_exposure }
    end

    it_behaves_like "has permissions", "read"
    it_behaves_like "has permissions", "update"
    it_behaves_like "has permissions", "destroy"

    describe_exposure :created_at do
      it { is_expected.to be_a_formatter_block_exposure }
      it { is_expected.to have_formatting("2022-01-01T15:00:00Z").with_object(object) }
      it { is_expected.not_to be_safe }
      it { is_expected.not_to be_merged }
      it { is_expected.not_to override_exposure }

      context "when has date" do
        it { is_expected.to have_conditions_met object }
      end

      context "when does not have date" do
        let(:object) { OpenStruct.new has_date: false }

        it { is_expected.not_to have_conditions_met object }
      end
    end
  end
end
```

## Entity Matchers

### `have_root(plural)`

Test that only the plural definition is set.

```ruby
class Entity < Grape::Entity
  root "items"
end

RSpec.describe Entity, type: :grape_entity do
  it { expect(described_class).to have_root "items" }
end
```

Chain `singular(singular)` to specify the expected singular definition.

```ruby
class Entity < Grape::Entity
  root "items", "item"
end

RSpec.describe Entity, type: :grape_entity do
  it { expect(described_class).to have_root("items").singular("item") }
end
```

## Exposure Matchers

Use `should`, `should_not`, `will`, `will_not`, `is_expected` to specify the expected value of the exposed attribute.

### `be_a_block_exposure`

Test that the exposed attribute is a block exposure.

```ruby
class Entity < Grape::Entity
  expose :block do |item, options|
    #...something
  end
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :block do
    it { is_expected.to be_a_block_exposure }
  end
  
  # Or
  
  its_exposure(:block) { is_expected.to be_a_block_exposure }
end
```

### `be_a_delegator_exposure`

Test that the exposed attribute is a delegator exposure.

```ruby
class Entity < Grape::Entity
  expose :id
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :id do
    it { is_expected.to be_a_delegator_exposure }
  end
  
  # Or
  
  its_exposure(:id) { is_expected.to be_a_delegator_exposure }
end
```

### `be_a_formatter_exposure`

Test that the exposed attribute is a formatter exposure using a symbol.

```ruby
class Entity < Grape::Entity
  expose :created_at, format_with: :iso_timestamp
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :created_at do
    it { is_expected.to be_a_formatter_exposure }
  end
  
  # Or
  
  its_exposure(:created_at) { is_expected.to be_a_formatter_exposure }
end
```

### `be_a_formatter_block_exposure`

Test that the exposed attribute is a formatter exposure using a proc.

```ruby
class Entity < Grape::Entity
  expose :created_at, format_with: ->(date) { date.iso8601 }
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :created_at do
    it { is_expected.to be_a_formatter_block_exposure }
  end
  
  # Or
  
  its_exposure(:created_at) { is_expected.to be_a_formatter_block_exposure }
end
```

### `be_a_nesting_exposure`

Test that the exposed attribute is a nesting exposure.

```ruby
class Entity < Grape::Entity
  expose :status do
    expose :status, as: :value
    expose :changed_at, as: :status_changed_at
  end
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :status do
    it { is_expected.to be_a_nesting_exposure }
  end
  
  # Or
  
  its_exposure(:status) { is_expected.to be_a_nesting_exposure }
end
```

### `be_a_represent_exposure`

Test that the exposed attribute is a represented exposure.

```ruby
class Entity < Grape::Entity
  expose :user, using: UserEntity
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :user do
    it { is_expected.to be_a_represent_exposure }
  end
  
  # Or
  
  its_exposure(:user) { is_expected.to be_a_represent_exposure }
end
```

### `be_merged`

Test that the exposed attribute is merged into the parent.

```ruby
class Entity < Grape::Entity
  expose :user, using: UserEntity, merge: true
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :user do
    it { is_expected.to be_merged }
  end
  
  # Or
  
  its_exposure(:user) { is_expected.to be_merged }
end
```

### `be_safe`

Test that the exposed attribute is safe.

```ruby
class Entity < Grape::Entity
  expose :user, using: UserEntity, safe: true
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :user do
    it { is_expected.to be_safe }
  end
  
  # Or
  
  its_exposure(:user) { is_expected.to be_safe }
end
```

### `be_using_class(entity)`

Test that the exposed attribute uses an entity presenter.

```ruby
class Entity < Grape::Entity
  expose :user, using: UserEntity
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :user do
    it { is_expected.to be_using_class(UserEntity) }
  end
  
  # Or
  
  its_exposure(:user) { is_expected.to be_using_class(UserEntity) }
end
```

### `have_conditions_met(object)`

Test that the exposed attribute conditions are met with a given object.

```ruby
class Entity < Grape::Entity
  expose :protected, if: ->(instance) { instance.is_a?(Admin) }
end

RSpec.describe Entity, type: :grape_entity do
  let(:admin) { Admin.new }
  let(:user) { User.new }
  
  describe_exposure :protected do
    it { is_expected.to have_conditions_met(admin) }
    it { is_expected.not_to have_conditions_met(user) }
  end
  
  # Or

  its_exposure(:protected) { is_expected.to have_conditions_met(admin) }
  its_exposure(:protected) { is_expected.not_to have_conditions_met(user) }
end
```

Chain with `with_options(options)` to pass an options hash to the attribute exposure's conditions.

```ruby
class Entity < Grape::Entity
  expose :status, if: :all
  expose :secret, if: { type: :admin }
end

RSpec.describe Entity, type: :grape_entity do
  let(:admin) { Admin.new }
  
  describe_exposure :status do
    it { is_expected.to have_conditions_met(admin).with_options(all: true) }
    it { is_expected.not_to have_conditions_met(admin) }
  end

  describe_exposure :secret do
    it { is_expected.to have_conditions_met(admin).with_options(type: :admin) }
    it { is_expected.not_to have_conditions_met(admin).with_options(type: :user) }
    it { is_expected.not_to have_conditions_met(admin) }
  end
  
  # Or

  its_exposure(:status) { is_expected.to have_conditions_met(admin).with_options(all: true) }
  its_exposure(:status) { is_expected.not_to have_conditions_met(admin) }
  its_exposure(:secret) { is_expected.to have_conditions_met(admin).with_options(type: :admin) }
  its_exposure(:secret) { is_expected.not_to have_conditions_met(admin).with_options(type: :user) }
  its_exposure(:secret) { is_expected.not_to have_conditions_met(admin) }
end
```

### `have_formatting(formatter)`

Test that the exposed attribute uses a given formatter.

```ruby
class Entity < Grape::Entity
  expose :created_at, format_with: :iso_timestamp
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :created_at do
    it { is_expected.to have_formatting :iso_timestamp }
  end
  
  # Or
  
  its_exposure(:created_at) { is_expected.to have_formatting :iso_timestamp }
end
```

Chain with `with_object(object)` when the formatter option is a Proc.

```ruby
class Entity < Grape::Entity
  expose :created_at, format_with: ->(date) { |date| date.iso8601 }
end

RSpec.describe Entity, type: :grape_entity do
  let(:date) { Time.utc 2022, 1, 22, 17, 0, 0 }
  
  describe_exposure :created_at do
    it { is_expected.to have_formatting("2022-01-22T17:00:00Z").with_object(date) }
  end
  
  # Or
  
  its_exposure(:created_at) { is_expected.to have_formatting("2022-01-22T17:00:00Z").with_object(date) }
end
```

### `have_key(key)`

Test that the exposed attribute uses an alias.

```ruby
class Entity < Grape::Entity
  expose :to_param, as: :id
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :to_param do
    it { is_expected.to have_key :id }
  end
  
  # Or
  
  its_exposure(:to_param) { is_expected.to have_key :id }
end
```

### `include_documentation(*docs)`

Test that the exposed attribute has the included documentation.

```ruby
class Entity < Grape::Entity
  expose :id, documentation: { type: Integer, desc: "Entity id" }
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :id do
    it { is_expected.to have_documentation :type, :desc }
    it { is_expected.to have_documentation :type }
    it { is_expected.to have_documentation :desc }
    it { is_expected.to have_documentation type: Integer }
    it { is_expected.to have_documentation desc: "Entity id" }
    it { is_expected.to have_documentation type: Integer, desc: "Entity id" }
  end
  
  # Or

  its_exposure(:id) { is_expected.to have_documentation :type, :desc }
  its_exposure(:id) { is_expected.to have_documentation :type }
  its_exposure(:id) { is_expected.to have_documentation :desc }
  its_exposure(:id) { is_expected.to have_documentation type: Integer }
  its_exposure(:id) { is_expected.to have_documentation desc: "Entity id" }
  its_exposure(:id) { is_expected.to have_documentation type: Integer, desc: "Entity id" }
end
```

### `override_exposure`

Test that the exposed attribute uses an alias.

```ruby
class BaseEntity < Grape::Entity
  expose :id
end

class Entity < BaseEntity
  expose :id, override: true do |instance, options|
    #...
  end
end

RSpec.describe Entity, type: :grape_entity do
  describe_exposure :id do
    it { is_expected.to override_exposure }
  end
  
  # Or
  
  its_exposure(:to_param) { is_expected.to override_exposure }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Report Issues

Bug reports and pull requests are welcome on GitHub at https://github.com/jefawks3/rspec-grape-entity.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
