# frozen_string_literal: true

module Form
  class InvalidFeedbackComponent < ViewComponent::Base
    def initialize(field_name:, form:, classes: [])
      @field_name = field_name
      @form = form
      @classes = classes
      super()
    end

    attr_reader :field_name, :form

    def call
      tag.div(class: classes) do
        errors.join(', ')
      end
    end

    private

    def errors
      form.object.errors[field_name]
    end

    def classes
      # Adding is-invalid to trigger the tab error.
      ComponentSupport.merge_classes('invalid-feedback', @classes, errors.present? ? 'is-invalid' : [])
    end
  end
end
