# frozen_string_literal: true

# Performs a direct deposit (without SDR API) and then broadcasts a redirect to the work show page.
class DirectDepositJob < ApplicationJob
  include Rails.application.routes.url_helpers

  # @param [WorkForm] work_form
  # @param [String] wait_id
  # @param [Boolean] deposit if true, deposit the work; otherwise, leave as draft
  def perform(work_form:, wait_id:, deposit:)
    content = Content.find(work_form.content_id)
    ContentDigester.call(content:) # Add MD5 checksums to content files
    cocina_object = ToCocina::Mapper.call(work_form:, content:)
    new_cocina_object = if work_form.persisted?
                          Sdr::Repository.open_if_needed(cocina_object:)
                                         .then { |cocina_object| Sdr::Repository.update(cocina_object:) }
                        else
                          Sdr::Repository.register(cocina_object:)
                        end
    druid = new_cocina_object.externalIdentifier
    ContentStager.call(content:, druid:)
    Sdr::Repository.accession(druid:) if deposit

    Turbo::StreamsChannel.broadcast_action_to wait_id, action: :redirect,
                                                       attributes: { href: work_path(druid:) }
  end

  def update(cocina_object:)
    Sdr::Repository.open_if_needed(cocina_object:)
  end
end
