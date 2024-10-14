# frozen_string_literal: true

class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Serializers::JSON

  def self.model_name
    # Remove the "Form" suffix from the class name.
    # This allows Rails magic such as route paths.
    model_name = method(:model_name).super_method.call.to_s
    ActiveModel::Name.new(self, nil, model_name.delete_suffix('Form'))
  end

  # @param deposit [Boolean] whether the form is being used for a deposit
  def valid?(deposit: false)
    @deposit = deposit
    super()
  end

  # This can be used to control validations specific to deposits.
  # For example: validates :authors, presence: { message: 'requires at least one author' }, if: :deposit?
  def deposit?
    @deposit
  end
end
