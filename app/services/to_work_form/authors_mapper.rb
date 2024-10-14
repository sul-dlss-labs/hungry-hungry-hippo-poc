# frozen_string_literal: true

module ToWorkForm
  # Map from Cocina model to Authors
  class AuthorsMapper
    def self.call(...)
      new(...).call
    end

    # @param [Cocina::Models::DRO,Cocina::Models::RequestDRO] cocina_object
    def initialize(cocina_object:)
      @cocina_object = cocina_object
    end

    # @return [Array<Author>]
    # rubocop:disable Metrics/AbcSize
    def call
      cocina_object.description.contributor.filter_map do |contributor|
        next unless contributor.type == 'person'

        AuthorForm.new(
          first_name: contributor.name.first.structuredValue.find { |name| name.type == 'forename' }.value,
          last_name: contributor.name.first.structuredValue.find { |name| name.type == 'surname' }.value
          # affiliations: affiliations_for(contributor)
        )
      end
    end
    # rubocop:enable Metrics/AbcSize

    private

    attr_reader :cocina_object

    # def affiliations_for(contributor)
    #   affiliation_notes = contributor.note.filter { |note| note.type == 'affiliation' }
    #   affiliation_notes.map do |note|
    #     affiliation_for(note)
    #   end
    # end

    # def affiliation_for(note)
    #   ror_identifier = note.identifier.find { |identifier| identifier.type == 'ROR' }
    #   AffiliationForm.new(organization: note.value, ror_id: ror_identifier&.uri)
    # end
  end
end
