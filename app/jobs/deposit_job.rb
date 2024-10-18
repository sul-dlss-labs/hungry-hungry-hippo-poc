# frozen_string_literal: true

# Performs a deposit and then broadcasts a redirect to the work show page.
class DepositJob < ApplicationJob
  include Rails.application.routes.url_helpers

  def perform(work_form:, deposit:, wait_id: nil)
    content = Content.find(work_form.content_id)
    ContentDigester.call(content:) # Add MD5 checksums to content files
    cocina_object = ToCocina::Mapper.call(work_form:, content:)
    druid = Sdr::Deposit.call(cocina_object:, content:, deposit:)
    return unless wait_id

    Turbo::StreamsChannel.broadcast_action_to wait_id, action: :redirect,
                                                       attributes: { href: work_path(druid:) }
  end
end
