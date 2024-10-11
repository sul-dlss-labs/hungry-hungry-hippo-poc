# frozen_string_literal: true

module Tab
  class PaneComponent < ViewComponent::Base
    def initialize(tab_name:, selected: false, controllers: [])
      @tab_name = tab_name
      @selected = selected
      @controllers = controllers
      super()
    end

    attr_reader :tab_name, :selected, :controllers

    def call
      tag.div(id: "#{tab_name}-pane",
              class: selected ? 'tab-pane fade show active' : 'tab-pane fade',
              role: 'tabpanel',
              'aria-labelledby': "#{@tab_name}-tab",
              tabindex: '0',
              data:) do
        content
      end
    end

    private

    def data
      { controller: controllers.join(' ') }
    end
  end
end
