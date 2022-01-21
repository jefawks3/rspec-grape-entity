# frozen_string_literal: true

module RSpec
  module Grape
    module Entity
      module Matchers
        module MatcherHelpers
          def entity_class_name(entity)
            entity.try(:name) || entity.class.name
          end

          def exposure_attribute(exposure, name)
            exposure.send name
          end

          def exposure_type(type)
            type = type.to_s.split("_").map { |w| w[0].upcase + w[1..] }.join
            Object.const_get "Grape::Entity::Exposure::#{type}Exposure"
          end
        end
      end
    end
  end
end
