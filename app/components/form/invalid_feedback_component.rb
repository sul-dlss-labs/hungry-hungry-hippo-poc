# frozen_string_literal: true

module Form
  class InvalidFeedbackComponent < ViewComponent::Base
    def initialize(field_name:, form:)
      @field_name = field_name
      @form = form
      super()
    end

    attr_reader :field_name, :form

    def call
      tag.div(class: 'invalid-feedback') do
        form.object.errors[field_name].join(', ')
      end
    end
  end
end
