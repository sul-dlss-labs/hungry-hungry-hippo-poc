# frozen_string_literal: true

module Element
  class ButtonComponent < ViewComponent::Base
    def initialize(label:, **options)
      @label = label
      @options = options
      super()
    end

    attr_reader :options, :label
  end
end
