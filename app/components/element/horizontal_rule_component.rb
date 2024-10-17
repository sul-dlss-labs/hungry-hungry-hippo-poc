# frozen_string_literal: true

module Element
  class HorizontalRuleComponent < ViewComponent::Base
    def call
      tag.hr
    end
  end
end
