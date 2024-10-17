# frozen_string_literal: true

module Element
  class ButtonLinkComponent < ViewComponent::Base
    def initialize(path:, label: nil, variant: nil, size: nil, **options)
      @label = label
      @path = path
      @variant = variant
      @size = size
      @options = options
      super()
    end

    def call
      link_to @path, class: classes, **@options do
        @label || content
      end
    end

    def classes
      Element::ButtonSupport.classes(variant: @variant, size: @size, classes: @classes)
    end
  end
end
