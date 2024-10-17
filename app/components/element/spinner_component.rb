# frozen_string_literal: true

module Element
  class SpinnerComponent < ViewComponent::Base
    def initialize(message: 'Loading...', variant: nil, hide_message: false, classes: [])
      @message = message
      @variant = variant
      @hide_message = hide_message
      @classes = classes
      super()
    end

    attr_reader :message

    def spinner_classes
      ComponentSupport.merge_classes('spinner-border', variant_class)
    end

    def message_classes
      @hide_message ? 'visually-hidden' : ''
    end

    def classes
      ComponentSupport.merge_classes(@classes)
    end

    private

    def variant_class
      return unless @variant

      "text-#{@variant}"
    end
  end
end
