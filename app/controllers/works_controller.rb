# frozen_string_literal: true

# Controller for a Work
class WorksController < ApplicationController
  def index
    @work_form = session[:work]
  end

  def new
    @work_form = WorkForm.new
  end

  def create
    @work_form = WorkForm.new(work_params)
    if @work_form.valid?
      session[:work] = @work_form
      redirect_to works_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def work_params
    params.require(:work).permit(:title, :abstract)
  end
end
