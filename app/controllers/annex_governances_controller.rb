# frozen_string_literal: true
class AnnexGovernancesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_annex_governance, except: [:index, :new, :create]

  def index
    @annex_governances = AnnexGovernance.by_governance_problem_asc
  end

  def show; end

  def edit; end

  def new
    @annex_governance = AnnexGovernance.new
  end

  def update
    if @annex_governance.update(annex_governance_params)
      redirect_to annex_governances_url, notice: 'Annex succesfully updated.'
    else
      render :edit, notice: @annex_governance.errors.full_messages
    end
  end

  def create
    if @annex_governance.save(annex_governance_params)
      redirect_to annex_governances_url, notice: 'Annex succesfully updated.'
    else
      render :new, notice: @annex_governance.errors.full_messages
    end
  end

  def destroy
    if @annex_governance.destroy
      redirect_to annex_governances_url, notice: 'Annex succesfully deleted.'
    else
      redirect_to annex_governances_url, notice: "There was an error and annex can't be deleted."
    end
  end

  private

    def set_annex_governance
      @annex_governance = AnnexGovernance.find(params[:id])
    end

    def annex_governance_params
      params.require(:annex_governance).permit(:governance_pillar, :governance_problem, :details)
    end

    def menu_highlight
      @menu_highlighted = :admin
    end
end
