# frozen_string_literal: true
class SpeciesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_species, except: [:index, :new, :create]

  def index
    @species = Species.by_name_asc.page params[:page]
  end

  def show; end

  def edit; end

  def new
    @species = Species.new
  end

  def update
    if @species.update(species_params)
      redirect_to species_index_url, notice: 'Species succesfully updated.'
    else
      render :edit, notice: @species.errors.full_messages
    end
  end

  def create
    if @species.save(species_params)
      redirect_to species_index_url, notice: 'Species succesfully updated.'
    else
      render :new, notice: @species.errors.full_messages
    end
  end

  def destroy
    if @species.destroy
      redirect_to species_index_url, notice: 'Species succesfully deleted.'
    else
      redirect_to species_index_url, notice: "There was an error and species can't be deleted."
    end
  end

  private

    def set_species
      @species = Species.find(params[:id])
    end

    def species_params
      params.require(:species).permit(:name, :species_class, :sub_species, :species_family, :species_kingdom,
                                      :scientific_name, :cites_status, :cites_id, :iucn_status, :common_name, country_ids: [])
    end

    def menu_highlight
      @menu_highlighted = :admin
    end
end
