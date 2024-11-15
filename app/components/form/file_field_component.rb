# frozen_string_literal: true

module Form
  class FileFieldComponent < Form::FieldComponent
    # Note that hidden_label defaults to true for a file field.
    def initialize(form:, field_name:, required: false, accept: nil, multiple: false, # rubocop:disable Metrics/ParameterLists
                   directory: false, input_options: {}, hidden_label: true)
      @accept = accept
      @multiple = multiple
      @directory = directory
      super(form:, field_name:, required:, input_options:, hidden_label:)
    end

    attr_reader :accept, :multiple

    def directory_option
      # This approach makes sure that webkitdirectory attribute is absent when false.
      {}.tap do |options|
        options[:webkitdirectory] = true if @directory
      end
    end
  end
end
