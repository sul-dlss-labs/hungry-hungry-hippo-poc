# frozen_string_literal: true

module Element
  class HelpTextComponent < ViewComponent::Base
    def initialize(text: nil, classes: [])
      @text = text
      @classes = classes
      super()
    end

    def call
      tag.p(@text || content, class: classes)
    end

    def classes
      ComponentSupport.merge_classes('text-muted', @classes)
    end
  end
end
