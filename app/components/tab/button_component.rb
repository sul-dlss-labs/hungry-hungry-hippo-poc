# frozen_string_literal: true

module Tab
  class ButtonComponent < ViewComponent::Base
    def initialize(label:, tab_name:, selected: false)
      @label = label
      @tab_name = tab_name
      @selected = selected
      super()
    end

    def call
      tag.div(
        class: classes,
        id: "#{tab_name}-tab",
        data: { bs_toggle: 'tab', bs_target: "##{pane_id}" },
        type: 'button',
        # role: 'tab',
        'aria-controls': pane_id,
        'aria-selected': selected
      ) do
        label
      end
    end

    private

    attr_reader :label, :tab_name, :selected

    def classes
      selected ? 'nav-link active' : 'nav-link'
    end

    def id
      "#{tab_name}-tab"
    end

    def pane_id
      "#{tab_name}-pane"
    end
  end
end
