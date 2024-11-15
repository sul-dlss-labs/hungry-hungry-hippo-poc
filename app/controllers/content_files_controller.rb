# frozen_string_literal: true

# Controller for a Work content file
class ContentFilesController < ApplicationController
  before_action :set_content_file

  def show; end

  def edit; end

  def update
    if @content_file.update(content_file_params)
      redirect_to content_file_path(@content_file)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @content_file.destroy
    redirect_to content_path(@content_file.content)
  end

  private

  def set_content_file
    @content_file = ContentFile.find(params[:id])
  end

  def content_file_params
    params.require(:content_file).permit(:filename)
  end
end
