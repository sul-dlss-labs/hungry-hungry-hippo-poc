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
        class: classes,
        # id: "#{tab_name}-tab",
        # data: { bs_toggle: 'tab', bs_target: "##{pane_id}" },
        type: 'button',
        # role: 'tab',
        # 'aria-controls': pane_id,
        # 'aria-selected': selected
        **options
      ) do
        label
      end
    end

    private

    def classes
      ComponentSupport.merge_classes('btn', variant_class, size_class, @classes)
    end

    def variant_class
      @variant ? "btn-#{@variant}" : nil
    end

    def size_class
      @size ? "btn-#{@size}" : nil
    end
  end
end
