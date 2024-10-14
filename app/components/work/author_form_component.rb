# frozen_string_literal: true

module Work
  class AuthorFormComponent < ViewComponent::Base
    def initialize(form:)
      @form = form
      super()
    end

    attr_reader :form
  end
end
