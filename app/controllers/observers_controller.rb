# frozen_string_literal: true
class ObserversController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_observer, except: [:index, :new, :create]

  def index
    @monitors = Observer.by_name_asc.page params[:page]
  end

  def show; end

  def edit; end

  def new
    @monitor = Observer.new
  end

  def update
    if @monitor.update(observer_params)
      redirect_to monitors_url, notice: 'Monitor succesfully updated.'
    else
      render :edit, notice: @monitor.errors.full_messages
    end
  end

  def create
    @monitor = Observer.new(observer_params)
    if @monitor.save
      redirect_to monitors_url, notice: 'Monitor succesfully updated.'
    else
      render :new, notice: @monitor.errors.full_messages
    end
  end

  def destroy
    if @monitor.destroy
      redirect_to monitors_url, notice: 'Monitor succesfully deleted.'
    else
      redirect_to monitors_url, notice: "There was an error and monitor can't be deleted."
    end
  end

  private

    def set_observer
      @monitor = Observer.find(params[:id])
    end

    def observer_params
      params.require(:observer).permit(:name, :organization, :observer_type, :logo, :country_id, user_ids: [])
    end

    def menu_highlight
      @menu_highlighted = :admin
    end
end
