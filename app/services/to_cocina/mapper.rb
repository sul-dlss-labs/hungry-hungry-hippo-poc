# frozen_string_literal: true

module ToCocina
  # Maps WorkForm to Cocina DRO
  class Mapper
    def self.call(...)
      new(...).call
    end

    # @param [WorkForm] work_form
    # @param [source_id] source_id
    def initialize(work_form:, source_id: nil)
      @work_form = work_form
      @source_id = source_id || "h3:object-#{Time.zone.now.iso8601}"
    end

    def call
      if work_form.druid.present?
        Cocina::Models.build(params)
      else
        Cocina::Models.build_request(params)
      end
    end

    private

    attr_reader :work_form, :source_id

    def params
      {
        externalIdentifier: work_form.druid,
        type: Cocina::Models::ObjectType.object,
        label: work_form.title,
        description: ToCocina::DescriptionMapper.call(work_form:),
        version: work_form.version,
        access: { view: 'world', download: 'world' },
        identification: { sourceId: source_id },
        administrative: { hasAdminPolicy: Settings.apo },
        structural: { contains: [] }
      }.compact
    end
  end
end
