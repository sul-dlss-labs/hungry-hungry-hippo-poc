# frozen_string_literal: true

module Form
  class FieldComponent < ViewComponent::Base
    def initialize(form:, field_name:, required: false, input_options: {})
      @form = form
      @field_name = field_name
      @required = required
      @input_options = input_options
      super()
    end

    attr_reader :form, :field_name, :required, :input_options
  end
end
