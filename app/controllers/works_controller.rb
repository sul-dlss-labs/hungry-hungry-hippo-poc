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
    # The deposit param determines whether extra validations for deposits are applied.
    if @work_form.valid?(deposit: deposit?)
      session[:work] = @work_form
      redirect_to works_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def work_params
    params.require(:work).permit(
      :title, :abstract,
      authors_attributes: %i[first_name last_name]
    )
  end

  def deposit?
    params[:commit] == 'Deposit'
  end
end
