# frozen_string_literal: true

# Service to copy content files to the workspace.
class ContentStager
  def self.call(...)
    new(...).call
  end

  def initialize(content:, druid:)
    @content = content
    @druid = druid
  end

  def call
    @zip_file = Zip::File.open(zip_filepath) if content.zip_file.attached?
    begin
      content.content_files.each do |content_file|
        if content_file.zip_content?
          stage_zip_content(content_file)
        elsif content_file.attached?
          stage_attached_content(content_file)
        end
      end
    ensure
      zip_file&.close
    end
  end

  private

  attr_reader :content, :druid, :zip_file

  def stage_zip_content(content_file)
    staging_filepath = staging_filepath_for(content_file)
    create_directory(staging_filepath)
    zip_file.extract(content_file.filename, staging_filepath)
  end

  def stage_attached_content(content_file)
    filepath = ActiveStorageSupport.filepath_for_blob(content_file.file.blob)
    staging_filepath = staging_filepath_for(content_file)
    create_directory(staging_filepath)
    FileUtils.cp filepath, staging_filepath
  end

  def staging_filepath_for(content_file)
    File.join(staging_content_path, content_file.filename)
  end

  def staging_content_path
    @staging_content_path ||= begin
      druid_tree_folder = DruidTools::Druid.new(druid, Settings.staging_location).path
      File.join(druid_tree_folder, 'content')
    end
  end

  def create_directory(filepath)
    FileUtils.mkdir_p File.dirname(filepath)
  end

  def zip_filepath
    ActiveStorageSupport.filepath_for_blob(content.zip_file.blob)
  end
end
