# frozen_string_literal: true

# Controller for a Work contents (files)
class ContentsController < ApplicationController
  before_action :set_content, only: %i[edit update wait show]
  def show
    @search_form = SearchForm.new(search_params)
    @content_files = @content.content_files.page(params[:page])
    @content_files = @content_files.where('filename LIKE ?', "%#{@search_form.query}%") if @search_form.query.present?
  end

  def edit; end

  def update
    if params.dig(:content, :zip_file).present?
      update_zip_file
      return redirect_to wait_content_path(@content)
    elsif params.dig(:content, :files).present?
      update_files
      return respond_to do |format|
        format.turbo_stream
      end
    end

    redirect_to edit_content_path(@content)
  end

  def wait; end

  private

  def set_content
    @content = Content.find(params[:id])
  end

  # ActionDispath::Http::UploadedFile only provides the base name.
  # This attempts to get the complete filename from the headers.
  def filename_for(file)
    if (matcher = file.headers.match(/filename="(.+)"/))
      matcher[1]
    else
      file.original_filename
    end
  end

  def update_zip_file
    @content.zip_file.attach(params[:content][:zip_file])
    ZipReadJob.perform_later(content: @content)
  end

  def update_files
    files = params[:content][:files].compact_blank
    files.each do |file|
      content_file = ContentFile.create!(content: @content, filename: filename_for(file), file_type: :attached,
                                         size: file.size, label: file.original_filename)
      content_file.file.attach(file)
    end
  end

  def search_params
    params.fetch(:search, {}).permit(:query)
  end
end
