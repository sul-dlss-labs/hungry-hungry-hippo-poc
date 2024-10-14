# frozen_string_literal: true

module Tab
  class NextButtonComponent < Element::ButtonComponent
    def initialize(tab_name:)
      super(label: 'Next',
            variant: :secondary,
            size: :sm,
            classes: 'mt-2',
            data: {
              controller: 'tab-next',
              tab_next_selector_value: "##{tab_name}-tab",
              action: 'click->tab-next#show'
            }
            )
    end
  end
end
