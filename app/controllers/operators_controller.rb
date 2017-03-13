# frozen_string_literal: true
class OperatorsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_operator, except: [:index, :new, :create]

  def index
    @operators = Operator.by_name_asc.page params[:page]
  end

  def show; end

  def edit; end

  def new
    @operator = Operator.new
  end

  def update
    if @operator.update(operator_params)
      redirect_to operators_url, notice: 'Operator succesfully updated.'
    else
      render :edit, notice: @operator.errors.full_messages
    end
  end

  def create
    if @operator.save(operator_params)
      redirect_to operators_url, notice: 'Operator succesfully updated.'
    else
      render :new, notice: @operator.errors.full_messages
    end
  end

  def destroy
    if @operator.destroy
      redirect_to operators_url, notice: 'Operator succesfully deleted.'
    else
      redirect_to operators_url, notice: "There was an error and operator can't be deleted."
    end
  end

  private

    def set_operator
      @operator = Operator.find(params[:id])
    end

    def operator_params
      params.require(:operator).permit(:name, :details, :operator_type, :logo, :country_id, :concession, user_ids: [])
    end

    def menu_highlight
      @menu_highlighted = :admin
    end
end
