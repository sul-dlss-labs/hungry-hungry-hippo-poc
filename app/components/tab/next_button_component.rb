# frozen_string_literal: true

module Tab
  class NextButtonComponent < Element::ButtonComponent
    def initialize(tab_name:)
      super(label: 'Next',
            class: 'btn btn-secondary btn-sm mt-2',
            data: {
              controller: 'tab-next',
              tab_next_selector_value: "##{tab_name}-tab",
              action: 'tab-next#show'
            }
            )
    end
  end
end
