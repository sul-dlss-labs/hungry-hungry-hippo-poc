# frozen_string_literal: true

module Form
  class SubmitComponent < ViewComponent::Base
    def initialize(form:)
      @form = form
      super()
    end

    attr_reader :form
  end
end
