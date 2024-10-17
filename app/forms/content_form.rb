# frozen_string_literal: true

# Form for a zip file
class ContentForm < ApplicationForm
  attribute :id, :integer
  attribute :zip_file

  def persisted?
    id.present?
  end
end
