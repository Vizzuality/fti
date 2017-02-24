# frozen_string_literal: true
class ObserversController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_observer, except: [:index, :new, :create]

  def index
    @observers = Observer.by_name_asc
  end

  def show; end

  def edit; end

  def new
    @observer = Observer.new
  end

  def update
    if @observer.update(observer_params)
      redirect_to monitors_url, notice: 'Monitor succesfully updated.'
    else
      render :edit, notice: @observer.errors.full_messages
    end
  end

  def create
    if @observer.save(observer_params)
      redirect_to monitors_url, notice: 'Monitor succesfully updated.'
    else
      render :new, notice: @observer.errors.full_messages
    end
  end

  def destroy
    if @observer.destroy
      redirect_to monitors_url, notice: 'Monitor succesfully deleted.'
    else
      redirect_to monitors_url, notice: "There was an error and monitor can't be deleted."
    end
  end

  private

    def set_observer
      @observer = Observer.find(params[:id])
    end

    def observer_params
      params.require(:observer).permit(:name, :organization, :observer_type, :country_id)
    end

    def menu_highlight
      @menu_highlighted = :admin
    end
end
