# frozen_string_literal: true

module Tab
  class ButtonComponent < Element::ButtonComponent
    def initialize(label:, tab_name:, selected: false)
      super(label:,
            class: selected ? 'nav-link active' : 'nav-link',
            id: "#{tab_name}-tab",
            data: { bs_toggle: 'tab', bs_target: "##{tab_name}-pane" },
            type: 'button',
            role: 'tab',
            'aria-controls': "#{tab_name}-pane",
            'aria-selected': selected
            )
    end
  end
end
