# frozen_string_literal: true

# Controller for a Work
class WorksController < ApplicationController
  before_action :set_cocina_object, only: %i[show edit]
  before_action :set_content, only: %i[create]

  def show
    @cocina_object = Sdr::Repository.find(druid: params[:druid])
    @status = Sdr::Repository.status(druid: params[:druid])
    @status_message = status_message_for(@status)
    @editable = @status.openable? || @status.open?
  end

  def new
    @work_form = WorkForm.new
    @content = Content.create!
    render :form
  end

  def edit
    @work_form = ToWorkForm::Mapper.call(cocina_object: @cocina_object)
    unless ToWorkForm::RoundtripValidator.rountrippable?(work_form: @work_form, cocina_object: @cocina_object)
      return render :edit_error
    end

    render :form
  end

  def create
    @work_form = WorkForm.new(work_params)
    # The deposit param determines whether extra validations for deposits are applied.
    if @work_form.valid?(deposit: deposit?)
      cocina_object = ToCocina::Mapper.call(work_form: @work_form)
      druid = Sdr::Deposit.call(cocina_object:, deposit: deposit?)
      redirect_to work_path(druid:)
    else
      render :form, status: :unprocessable_entity
    end
  end

  def update
    @work_form = WorkForm.new(work_params.merge(druid: params[:druid]))
    # The deposit param determines whether extra validations for deposits are applied.
    if @work_form.valid?(deposit: deposit?)
      cocina_object = ToCocina::Mapper.call(work_form: @work_form)
      Sdr::Update.call(cocina_object:, deposit: deposit?)
      redirect_to work_path(druid: params[:druid])
    else
      render :form, status: :unprocessable_entity
    end
  end

  private

  def work_params
    params.require(:work).permit(
      :version, :title, :abstract,
      authors_attributes: %i[first_name last_name]
    )
  end

  def deposit?
    params[:commit] == 'Deposit'
  end

  def set_cocina_object
    @cocina_object = Sdr::Repository.find(druid: params[:druid])
  end

  def set_content
    @content = Content.find(params[:work][:content_id])
  end

  def status_message_for(status)
    if status.open?
      'This is a draft.'
    elsif status.openable?
      'This is the last deposited version.'
    else
      'This work is depositing.'
    end
  end
end
