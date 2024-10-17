# frozen_string_literal: true

require 'zip'

# Job to read the contents of a zip file and create a Content File for each entry
# rubocop:disable Rails/SkipsModelValidations
class ZipReadJob < ApplicationJob
  def perform(content:, zip_blob:)
    delete_existing_for(content)

    content_file_params = content_file_params_for(content, zip_blob)
    insert_content_files(content_file_params, zip_blob)

    # Broadcast that the content has been updated
    content.broadcast
  end

  def delete_existing_for(content)
    content_file_ids = content.content_files.pluck(:id)
    content_file_ids.in_groups_of(1000, false) do |content_file_ids_group|
      ActiveStorage::Attachment.where(record_id: content_file_ids_group).delete_all
    end
    content.content_files.delete_all
  end

  def content_file_params_for(content, zip_blob)
    content_file_params = []
    Zip::File.open(ActiveStorage::Blob.service.path_for(zip_blob.key)) do |zip|
      zip.each do |entry|
        content_file_params << { content_id: content.id, filename: entry.name,
                                 file_type: :zip_content, size: entry.size,
                                 label: entry.name }
      end
    end
    content_file_params
  end

  def insert_content_files(content_file_params, zip_blob)
    # Adding in groups with insert_all is much faster than individual creates
    content_file_params.in_groups_of(1000, false) do |content_file_params_group|
      results = ContentFile.insert_all!(content_file_params_group)
      attachment_params = results.map do |result|
        { name: 'file', record_type: 'ContentFile', record_id: result['id'], blob_id: zip_blob.id }
      end
      ActiveStorage::Attachment.insert_all!(attachment_params)
    end
  end
end
# rubocop:enable Rails/SkipsModelValidations
