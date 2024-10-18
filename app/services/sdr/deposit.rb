# frozen_string_literal: true

module Sdr
  # Service to deposit a work via SDR API.
  class Deposit
    class Error < StandardError; end

    def self.call(...)
      new(...).call
    end

    # @param [Cocina::Models::RequestDRO] cocina_object
    # @param [Array<ContentFile>] content
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
      upload_responses = upload_files
      new_cocina_object = SdrClient::RedesignedClient::UpdateDroWithFileIdentifiers.update(request_dro: cocina_object,
                                                                                           upload_responses:)

      SdrClient::RedesignedClient::CreateResource.run(accession: deposit?,
                                                      metadata: new_cocina_object)
    end

    def await_job_status(job_id:)
      job_status = SdrClient::RedesignedClient::JobStatus.new(job_id:)
      raise Error, "Deposit failed: #{job_status.errors.join('; ')}" unless job_status.wait_until_complete

      job_status
    end

    def deposit?
      @deposit
    end

    def direct_upload_request_for(content_file)
      SdrClient::RedesignedClient::DirectUploadRequest.new(
        checksum: hex_to_base64_digest(content_file.md5_digest),
        byte_size: content_file.size,
        content_type: content_file.mime_type,
        filename: content_file.filename
      )
    end

    def upload_content_files
      @upload_content_files ||= content.content_files.where(file_type: %w[attached zip_content])
    end

    def zip_filepath
      ActiveStorage::Blob.service.path_for(content.zip_file.blob.key)
    end

    def hex_to_base64_digest(hexdigest)
      [[hexdigest].pack('H*')].pack('m0')
    end

    def filepath_or_io_for(content_file, zip_file)
      if content_file.attached?
        ActiveStorage::Blob.service.path_for(content_file.file.blob.key)
      else
        # Reading directly from the zip without writing to disk
        zip_file.get_input_stream(content_file.filename)
      end
    end

    def upload_files
      # upload_responses is an Array<DirectUploadResponse>.
      zip_file = Zip::File.open(zip_filepath) if content.zip_file.attached?
      begin
        content.content_files.map do |content_file|
          SdrClient::RedesignedClient::UploadFile.upload(direct_upload_request: direct_upload_request_for(content_file),
                                                         filepath_or_io: filepath_or_io_for(content_file, zip_file))
        end
      ensure
        zip_file&.close
      end
    end
  end
end
