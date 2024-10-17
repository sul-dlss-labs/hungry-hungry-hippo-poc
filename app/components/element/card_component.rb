# frozen_string_literal: true

module Element
  class CardComponent < ViewComponent::Base
    renders_one :body, 'BodyComponent'

    def initialize(classes: [], header_label: nil)
      @header_label = header_label
      @classes = classes
      super()
    end

    def classes
      ComponentSupport.merge_classes('card', @classes)
    end

    attr_reader :header_label

    class BodyComponent < ViewComponent::Base
      def initialize(classes: [], **options)
        @classes = classes
        @options = options
        super()
      end

      def call
        tag.div(class: classes, **@options) do
          content
        end
      end

      def classes
        ComponentSupport.merge_classes('card-body', @classes)
      end
    end
  end
end
