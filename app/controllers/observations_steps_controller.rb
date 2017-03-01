# frozen_string_literal: true
class ObservationsStepsController < ApplicationController
  before_action :authenticate_user!
  # load_and_authorize_resource

  include Wicked::Wizard

  before_action :build_observation, except: :new
  before_action :set_step,          only: [:show, :update]

  steps *Observation.form_steps.map {|x| x[:page]}

  def new
    reset_session
    redirect_to wizard_path(Wicked::FIRST_STEP)
  end

  def show
    render_wizard
  end

  def update
    move_forward
  end

  private

    def observation_params
      step_params = Observation.form_steps.select{|x| x[:page] == step}.first
      params.require(:observation).permit(step_params[:params])
    end

    def set_step
      @observation.form_step = step
    end

    def reset_session
      session[:observation] = {}
    end

    def move_forward(next_step_name = next_step)
      if @observation.valid?
        if next_step_name == Wicked::FINISH_STEP
          @observation.save
          redirect_to observations_path, notice: 'Observation created successfully'
        else
          save_observation
          redirect_to wizard_path(next_step_name)
        end

      else
        render_wizard
      end
    end

    def build_observation
      @observation = Observation.new
      @observation.assign_attributes session[:observation]
      @observation.assign_attributes observation_params if params[:observation]
    end

    def save_observation
      session[:observation] = @observation.attributes
    end

    def menu_highlight
      @menu_highlighted = :observations
    end
end
