# frozen_string_literal: true

module Sdr
  # Service to update a work via SDR API.
  class Update
    class Error < StandardError; end

    def self.call(...)
      new(...).call
    end

    # @param [Cocina::Models::DRO] cocina_object new version of the cocina object
    # @param [Boolean] deposit true to deposit the work; otherwise, leave as draft
    def initialize(cocina_object:, deposit: true)
      @cocina_object = cocina_object
      @deposit = deposit
    end

    # @return [String] job_id of the update job
    # @raise [Error] if there is an error updating the work
    def call
      job_id = update
      await_job_status(job_id:)
      job_id
    end

    private

    attr_reader :cocina_object

    def update
      SdrClient::RedesignedClient::UpdateResource.run(model: cocina_object, accession: deposit?)
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
