# frozen_string_literal: true
class CountriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_country, except: [:index, :new, :create]

  def index
    @countries = Country.by_name_asc
  end

  def show; end

  def edit; end

  def new
    @country = Country.new
  end

  def update
    if @country.update(country_params)
      redirect_to countries_url, notice: 'Country succesfully updated.'
    else
      render :edit, notice: @country.errors.full_messages
    end
  end

  def create
    if @country.save(country_params)
      redirect_to countries_url, notice: 'Country succesfully updated.'
    else
      render :new, notice: @country.errors.full_messages
    end
  end

  def destroy
    if @country.destroy
      redirect_to countries_url, notice: 'Country succesfully deleted.'
    else
      redirect_to countries_url, notice: "There was an error and country can't be deleted."
    end
  end

  private

    def set_country
      @country = Country.find(params[:id])
    end

    def country_params
      params.require(:country).permit(:name, :region_name, :iso, :region_iso, :country_centroid, :region_centroid)
    end

    def menu_highlight
      @menu_highlighted = :countries
    end
end
