# frozen_string_literal: true

# Model for a content file
class ContentFile < ApplicationRecord
  belongs_to :content
  has_one_attached :file

  enum :file_type, attached: 'attached', zip_content: 'zip_content', deposited: 'deposited'
end
