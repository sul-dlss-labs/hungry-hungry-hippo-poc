# frozen_string_literal: true

module ToWorkForm
  # Validates that a cocina object can be converted to a work form and then back without loss.
  class RoundtripValidator
    def self.rountrippable?(...)
      new(...).call
    end

    # @param [WorkForm] work_form
    # @param [Cocina::Models::DRO] cocina_object
    def initialize(work_form:, cocina_object:)
      @work_form = work_form
      @original_cocina_object = cocina_object
    end

    # @return [Boolean] true if the work form can be converted to a cocina object and back without loss
    def call
      roundtripped_cocina_object == original_cocina_object
    end

    private

    attr_reader :work_form, :original_cocina_object

    def roundtripped_cocina_object
      ToCocina::Mapper.call(work_form:, source_id: original_cocina_object.identification&.sourceId)
    end
  end
end
