# frozen_string_literal: true

module Form
  class FieldComponent < ViewComponent::Base
    def initialize(form:, field_name:)
      @form = form
      @field_name = field_name
      super()
    end

    attr_reader :form, :field_name
  end
end
