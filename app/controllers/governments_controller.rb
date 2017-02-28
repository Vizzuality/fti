# frozen_string_literal: true
class GovernmentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_government, except: [:index, :new, :create]

  def index
    @governments = Government.by_entity_asc.page params[:page]
  end

  def show; end

  def edit; end

  def new
    @government = Government.new
  end

  def update
    if @government.update(government_params)
      redirect_to governments_url, notice: 'Government succesfully updated.'
    else
      render :edit, notice: @government.errors.full_messages
    end
  end

  def create
    if @government.save(government_params)
      redirect_to governments_url, notice: 'Government succesfully updated.'
    else
      render :new, notice: @government.errors.full_messages
    end
  end

  def destroy
    if @government.destroy
      redirect_to governments_url, notice: 'Government succesfully deleted.'
    else
      redirect_to governments_url, notice: "There was an error and government can't be deleted."
    end
  end

  private

    def set_government
      @government = Government.find(params[:id])
    end

    def government_params
      params.require(:government).permit(:country_id, :government_entity, :details)
    end

    def menu_highlight
      @menu_highlighted = :admin
    end
end
