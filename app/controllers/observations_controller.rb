# frozen_string_literal: true
class ObservationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_observation, only:   [:show, :edit, :update, :destroy]
  before_action :set_user,        except: [:index, :show]

  def index
    @observations = Observation.by_date_desc.page params[:page]
  end

  def show; end

  def edit; end

  def update
    if @observation.update(observation_params)
      redirect_to observations_url, notice: 'Observation succesfully updated.'
    else
      render :edit, notice: @observation.errors.full_messages
    end
  end

  def destroy
    if @observation.destroy
      redirect_to observations_url, notice: 'Observation succesfully deleted.'
    else
      redirect_to observations_url, notice: "There was an error and observation can't be deleted."
    end
  end

  private

    def set_observation
      @observation = Observation.find(params[:id])
    end

    def set_user
      @user = current_user
    end

    def observation_params
      params.require(:observation).permit(:pv, :operator_opinion, :litigation_status, :observation_type, :id,
                                          :user_id, :publication_date, :country_id, :annex_operator_id, :annex_governance_id,
                                          :observer_id, :operator_id, :government_id, :severity_id, :active, :locale,
                                          :details, :evidence, { photos_attributes: [:id, :name, :attachment, :_destroy] },
                                          { documents_attributes: [:id, :name, :attachment, :document_type, :_destroy] }, :species_ids)
    end

    def menu_highlight
      @menu_highlighted = :observations
    end
end
