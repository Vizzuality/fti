# frozen_string_literal: true
class LawsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_law, except: [:index, :new, :create]

  def index
    @laws = Law.by_legal_reference_asc.page params[:page]
  end

  def show; end

  def edit; end

  def new
    @law = Law.new
  end

  def update
    if @law.update(law_params)
      redirect_to laws_url, notice: 'Law succesfully updated.'
    else
      render :edit, notice: @law.errors.full_messages
    end
  end

  def create
    if @law.save(law_params)
      redirect_to laws_url, notice: 'Law succesfully updated.'
    else
      render :new, notice: @law.errors.full_messages
    end
  end

  def destroy
    if @law.destroy
      redirect_to laws_url, notice: 'Law succesfully deleted.'
    else
      redirect_to laws_url, notice: "There was an error and law can't be deleted."
    end
  end

  private

    def set_law
      @law = Law.find(params[:id])
    end

    def law_params
      params.require(:law).permit(:country_id, :vpa_indicator, :legal_reference, :legal_penalty)
    end

    def menu_highlight
      @menu_highlighted = :admin
    end
end
