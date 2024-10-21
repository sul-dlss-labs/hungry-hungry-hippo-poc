# frozen_string_literal: true

module Sdr
  # Service to upload files to SDR
  class UploadFiles
    def self.call(...)
      new(...).call
    end

    # @param [Content] content the content to upload
    def initialize(content:)
      @content = content
    end

    # @return [Array<DirectUploadResponse>] responses from the upload
    def call
      zip_file = Zip::File.open(zip_filepath) if content.zip_file.attached?
      begin
        upload_content_files.map do |content_file|
          SdrClient::RedesignedClient::UploadFile.upload(direct_upload_request: direct_upload_request_for(content_file),
                                                         filepath_or_io: filepath_or_io_for(content_file, zip_file))
        end
      ensure
        zip_file&.close
      end
    end

    private

    attr_reader :content

    def upload_content_files
      content.content_files.where(file_type: %w[attached zip_content])
    end

    def zip_filepath
      ActiveStorage::Blob.service.path_for(content.zip_file.blob.key)
    end

    def direct_upload_request_for(content_file)
      SdrClient::RedesignedClient::DirectUploadRequest.new(
        checksum: hex_to_base64_digest(content_file.md5_digest),
        byte_size: content_file.size,
        content_type: content_file.mime_type,
        filename: content_file.filename
      )
    end

    def filepath_or_io_for(content_file, zip_file)
      if content_file.attached?
        ActiveStorage::Blob.service.path_for(content_file.file.blob.key)
      else
        # Reading directly from the zip without writing to disk
        zip_file.get_input_stream(content_file.filename)
      end
    end

    def hex_to_base64_digest(hexdigest)
      [[hexdigest].pack('H*')].pack('m0')
    end
  end
end
