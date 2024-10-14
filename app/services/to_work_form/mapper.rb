# frozen_string_literal: true

module ToWorkForm
  # Maps Cocina DRO to WorkForm
  class Mapper
    def self.call(...)
      new(...).call
    end

    def initialize(cocina_object:)
      @cocina_object = cocina_object
    end

    def call
      WorkForm.new(params)
    end

    private

    attr_reader :cocina_object

    def params
      {
        druid: cocina_object.externalIdentifier,
        version: cocina_object.version,
        title: CocinaSupport.title_for(cocina_object:),
        authors: ToWorkForm::AuthorsMapper.call(cocina_object:),
        abstract: cocina_object.description.note.find { |note| note.type == 'abstract' }&.value
        # keywords:,
        # related_resource_citation:,
        # related_resource_doi:,
        # collection_druid: CocinaSupport.collection_druid_for(cocina_object:)
      }
    end
  end
end
