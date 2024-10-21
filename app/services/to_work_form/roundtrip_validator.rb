# frozen_string_literal: true

module ToWorkForm
  # Validates that a cocina object can be converted to a work form and then back without loss.
  class RoundtripValidator
    def self.rountrippable?(...)
      new(...).call
    end

    # @param [WorkForm] work_form
    # @param [Content] content
    # @param [Cocina::Models::DRO] cocina_object
    def initialize(work_form:, content:, cocina_object:)
      @work_form = work_form
      @content = content
      @original_cocina_object = cocina_object
    end

    # @return [Boolean] true if the work form can be converted to a cocina object and back without loss
    def call
      if roundtripped_cocina_object == original_cocina_object
        true
      else
        Rails.logger.info("Roundtrip failed. Original: #{CocinaSupport.pretty(cocina_object: original_cocina_object)}")
        Rails.logger.info("Roundtripped: #{CocinaSupport.pretty(cocina_object: roundtripped_cocina_object)}")
        false
      end
    end

    private

    attr_reader :work_form, :original_cocina_object, :content

    def roundtripped_cocina_object
      ToCocina::Mapper.call(work_form:, content:, source_id: original_cocina_object.identification&.sourceId)
    end
  end
end
