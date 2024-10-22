# frozen_string_literal: true

module Form
  class SubmitComponent < ViewComponent::Base
    def initialize(form:, label: nil, variant: :primary, classes: [], **options)
      @form = form
      @label = label
      @variant = variant
      @options = options
      @classes = classes
      super()
    end

    attr_reader :form, :label

    def call
      form.submit(label, class: Element::ButtonSupport.classes(variant: @variant, classes:), **@options)
    end

    def classes
      ComponentSupport.merge_classes(@classes)
    end
  end
end
