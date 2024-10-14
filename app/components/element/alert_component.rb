# frozen_string_literal: true

module Element
  class AlertComponent < ViewComponent::Base
    def initialize(message:, classes: [], variant: :primary, **options)
      @message = message
      @classes = classes
      @variant = variant
      @options = options
      super()
    end

    attr_reader :options, :message

    def call
      tag.div(
        class: ComponentSupport.merge_classes('alert', variant_class, @classes),
        role: 'alert',
        **options
      ) do
        message
      end
    end

    private

    def variant_class
      "alert-#{@variant}"
    end
  end
end
