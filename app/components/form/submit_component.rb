# frozen_string_literal: true

module Form
  class SubmitComponent < ViewComponent::Base
    def initialize(form:, label: nil, variant: :primary, **options)
      @form = form
      @label = label
      @variant = variant
      @options = options
      super()
    end

    attr_reader :form, :label

    def call
      form.submit(label, class: Element::ButtonSupport.classes(variant: @variant, classes: 'mt-2'), **@options)
    end
  end
end
