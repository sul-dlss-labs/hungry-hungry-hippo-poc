# frozen_string_literal: true

module Sdr
  # Service to deposit a work via SDR API.
  class Deposit
    class Error < StandardError; end

    def self.call(...)
      new(...).call
    end

    # @param [Cocina::Models::RequestDRO] cocina_object
    # @param [Content] content
    # @param [Boolean] deposit true to deposit the work; otherwise, leave as draft
    def initialize(cocina_object:, content:, deposit: true)
      @cocina_object = cocina_object
      @content = content
      @deposit = deposit
    end

    # @raise [Error] if there is an error depositing the work
    # @return [String] druid of the deposited work
    def call
      job_id = deposit
      job_status = await_job_status(job_id:)

      job_status.druid
    end

    private

    attr_reader :cocina_object, :content

    delegate :version, to: :cocina_object

    def deposit
      upload_responses = Sdr::UploadFiles.call(content:)
      new_cocina_object = SdrClient::RedesignedClient::UpdateDroWithFileIdentifiers.update(request_dro: cocina_object,
                                                                                           upload_responses:)
      if cocina_object.is_a?(Cocina::Models::RequestDRO)
        SdrClient::RedesignedClient::CreateResource.run(accession: deposit?, metadata: new_cocina_object)
      else
        SdrClient::RedesignedClient::UpdateResource.run(model: new_cocina_object, accession: deposit?)
      end
    end

    def await_job_status(job_id:)
      job_status = SdrClient::RedesignedClient::JobStatus.new(job_id:)
      raise Error, "Deposit failed: #{job_status.errors.join('; ')}" unless job_status.wait_until_complete

      job_status
    end

    def deposit?
      @deposit
    end
  end
end
