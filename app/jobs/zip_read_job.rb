# frozen_string_literal: true

require 'zip'

# Job to read the contents of a zip file and create a Content File for each entry
# rubocop:disable Rails/SkipsModelValidations
class ZipReadJob < ApplicationJob
  def perform(content:)
    @content = content

    delete_existing
    insert_content_files

    # Broadcast that the content has been updated
    content.broadcast
  end

  attr_reader :content

  def zip_blob
    content.zip_file.blob
  end

  def delete_existing
    content_file_ids = content.content_files.pluck(:id)
    content_file_ids.in_groups_of(1000, false) do |content_file_ids_group|
      ActiveStorage::Attachment.where(record_id: content_file_ids_group).delete_all
    end
    content.content_files.delete_all
  end

  def content_file_params
    [].tap do |content_file_params|
      Zip::File.open(ActiveStorage::Blob.service.path_for(zip_blob.key)) do |zip|
        zip.each do |entry|
          content_file_params << { content_id: content.id, filename: entry.name,
                                   file_type: :zip_content, size: entry.size,
                                   label: entry.name }
        end
      end
    end
  end

  def insert_content_files
    # Adding in groups with insert_all is much faster than individual creates
    content_file_params.in_groups_of(1000, false) do |content_file_params_group|
      ContentFile.insert_all!(content_file_params_group)
    end
  end
end
# rubocop:enable Rails/SkipsModelValidations
