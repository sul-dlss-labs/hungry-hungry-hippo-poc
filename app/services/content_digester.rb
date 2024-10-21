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
        next if content_file.md5_digest.present? && content_file.sha1_digest.present?

        content_file.update!(digests_for(content_file))
      end
    ensure
      zip_file&.close
    end
  end

  private

  attr_reader :content, :zip_file

  def digests_for(content_file)
    stream = if content_file.attached?
               File.open(ActiveStorageSupport.filepath_for_blob(content_file.file.blob))
             else
               zip_file.get_input_stream(content_file.filename)
             end
    digests_from_stream(stream)
  end

  def digests_from_stream(stream)
    md5 = Digest::MD5.new
    sha1 = Digest::SHA1.new
    while (buffer = stream.read(4096))
      md5.update(buffer)
      sha1.update(buffer)
    end
    { md5_digest: md5.hexdigest, sha1_digest: sha1.hexdigest }
  end

  def base64_to_hex(base64_string)
    binary_data = Base64.decode64(base64_string)
    binary_data.unpack1('H*')
  end

  def zip_filepath
    ActiveStorageSupport.filepath_for_blob(content.zip_file.blob)
  end
end
