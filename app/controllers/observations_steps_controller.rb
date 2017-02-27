class ObservationsStepsController < ApplicationController
  include Wicked::Wizard

  before_action :build_observation, except: :new

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

  def reset_session
    session[:observation] = {}
  end

  def move_forward(next_step_name = next_step)
    if @observation.valid?
      save_observation
      redirect_to wizard_path(next_step_name)
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
end