# frozen_string_literal: true

module Element
  class ButtonComponent < ViewComponent::Base
    def initialize(label:, classes: [], variant: nil, size: nil, **options)
      @label = label
      @classes = classes
      @variant = variant
      @size = size
      @options = options
      super()
    end

    attr_reader :options, :label

    def call
      tag.buttons(
        class: Element::ButtonSupport.classes(variant: @variant, size: @size, classes: @classes),
        type: 'button',
        **options
      ) do
        label
      end
    end
  end
end
