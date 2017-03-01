# frozen_string_literal: true
class AnnexOperatorsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_annex_operator, except: [:index, :new, :create]

  def index
    @annex_operators = AnnexOperator.by_illegality_asc.page params[:page]
  end

  def show; end

  def edit; end

  def new
    @annex_operator = AnnexOperator.new
  end

  def update
    if @annex_operator.update(annex_operator_params)
      redirect_to annex_operators_url, notice: 'Annex succesfully updated.'
    else
      render :edit, notice: @annex_operator.errors.full_messages
    end
  end

  def create
    if @annex_operator.save(annex_operator_params)
      redirect_to annex_operators_url, notice: 'Annex succesfully updated.'
    else
      render :new, notice: @annex_operator.errors.full_messages
    end
  end

  def destroy
    if @annex_operator.destroy
      redirect_to annex_operators_url, notice: 'Annex succesfully deleted.'
    else
      redirect_to annex_operators_url, notice: "There was an error and annex can't be deleted."
    end
  end

  private

    def set_annex_operator
      @annex_operator = AnnexOperator.find(params[:id])
    end

    def annex_operator_params
      params.require(:annex_operator).permit(:country_id, :law_ids, :illegality, :details)
    end

    def menu_highlight
      @menu_highlighted = :admin
    end
end
