# frozen_string_literal: true

module Form
  class FieldComponent < ViewComponent::Base
    def initialize(form:, field_name:, required: false, input_options: {}, hidden_label: false)
      @form = form
      @field_name = field_name
      @required = required
      @input_options = input_options
      @hidden_label = hidden_label
      super()
    end

    attr_reader :form, :field_name, :required, :input_options

    # Override in subclasses for a different label class
    def label_class
      'form-label'
    end

    def label_classes
      ComponentSupport.merge_classes(label_class, @hidden_label ? 'visually-hidden' : nil)
    end
  end
end
