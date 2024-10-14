# frozen_string_literal: true

# Form for a Work
class WorkForm < ApplicationForm
  attribute :title, :string
  validates :title, presence: true

  attribute :abstract, :string

  attribute :authors, array: true, default: -> { [] }
  before_validation do
    authors.compact_blank!
  end
  validate :authors_are_valid
  validates :authors, presence: { message: 'requires at least one author' }, if: :deposit?

  def authors_attributes=(attributes)
    self.authors = attributes.map { |_, author| AuthorForm.new(author) }
  end

  def authors_are_valid
    authors.each do |author|
      next if author.valid?

      author.errors.each do |error|
        errors.add("authors.#{authors.index(author)}.#{error.attribute}", error.message)
      end
    end
  end
end
