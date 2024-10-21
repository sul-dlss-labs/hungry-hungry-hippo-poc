# frozen_string_literal: true

# Form for a Work
class WorkForm < ApplicationForm
  attribute :druid, :string
  alias id druid

  def persisted?
    druid.present?
  end

  attribute :content_id, :integer
  attribute :lock, :string

  attribute :version, :integer, default: 1

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

  # This is for serialization / deserialization
  # Similar will need to be added for other nested model forms.
  # j = work_form.to_json
  # new_work_form = WorkForm.new
  # new_work_form.attributes = j
  def attributes=(attrs)
    if attrs['authors']
      self.authors = attrs.delete('authors').map do |author_attrs|
        AuthorForm.new.from_json(author_attrs.to_json)
      end
    end
    super
  end
end
