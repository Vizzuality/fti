# frozen_string_literal: true
class ObservationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource except: [:create, :validate_observation]

  before_action :set_observation,  only:   [:show, :edit, :update, :destroy]
  before_action :set_user,         except: [:index, :show]
  before_action :load_observation, except: [:index, :show, :edit, :update, :validate_observation, :destroy]

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

  def validate_observation
    current_step = params[:current_step]

    @wizard_observation                        = observation_for_step(current_step)
    @wizard_observation.observation.attributes = observation_params.merge(user_id: @user.id)
    session[:observation_attributes]           = @wizard_observation.observation.attributes

    if @wizard_observation.valid?
      next_step = observation_next_step(current_step)
      create and return unless next_step

      redirect_to action: next_step
    else
      render current_step
    end
  end

  def create
    if @wizard_observation.observation.save
      session[:observation_attributes] = nil
      redirect_to observations_url, notice: 'Observation succesfully created!'
    else
      redirect_to({ action: Wizard::Observation::STEPS.first }, alert: 'There were a problem when creating the observation.')
    end
  end

  # def create
  #   @observation = @user.observations.build(observation_params)
  #   if @observation.save
  #     redirect_to observations_url, notice: 'Observation succesfully updated.'
  #   else
  #     render :new, notice: @observation.errors.full_messages
  #   end
  # end

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

    def load_observation
      @wizard_observation = observation_for_step(action_name)
    end

    def observation_next_step(step)
      Wizard::Observation::STEPS[Wizard::Observation::STEPS.index(step) + 1]
    end

    def observation_for_step(step)
      "Wizard::Observation::#{step.camelize}".constantize.new(session[:observation_attributes])
    end

    def observation_params
      params.require(:observation).permit(:pv, :operator_opinion, :litigation_status, :observation_type, :id,
                                          :user_id, :publication_date, :country_id, :annex_operator_id, :annex_governance_id,
                                          :observer_id, :operator_id, :government_id, :severity_id, :active, :locale,
                                          :details, :evidence, { photos_attributes: [:id, :name, :attachment, :_destroy] },
                                          { documents_attributes: [:id, :name, :attachment, :_destroy] }, :species_ids)
    end

    def menu_highlight
      @menu_highlighted = :observations
    end

    class InvalidStep < StandardError; end
end
