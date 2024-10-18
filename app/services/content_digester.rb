# frozen_string_literal: true

# Adds MD5 to Content Files since needed for deposit.
class ContentDigester
  def self.call(...)
    new(...).call
  end

  # @param [Content] content
  def initialize(content:)
    @content = content
  end

  def call
    @zip_file = Zip::File.open(zip_filepath) if content.zip_file.attached?
    begin
      content.content_files.each do |content_file|
        next if content_file.md5_digest.present?

        content_file.md5_digest = md5_for(content_file)
      end
    ensure
      zip_file&.close
    end
  end

  private

  attr_reader :content, :zip_file

  def md5_for(content_file)
    if content_file.attached?
      base64_to_hex(content_file.file.checksum)
    else
      md5_from_zip_file(content_file)
    end
  end

  def md5_from_zip_file(content_file)
    md5 = Digest::MD5.new
    input_stream = zip_file.get_input_stream(content_file.filename)
    while (buffer = input_stream.read(4096))
      md5.update(buffer)
    end
    md5.hexdigest
  end

  def base64_to_hex(base64_string)
    binary_data = Base64.decode64(base64_string)
    binary_data.unpack1('H*')
  end

  def zip_filepath
    ActiveStorage::Blob.service.path_for(content.zip_file.blob.key)
  end
end
