# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_current_user, only: :dashboard
  before_action :set_user, except: [:index, :dashboard]

  def index
    @users = User.all
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_url(@user), notice: 'User succesfully updated.'
    else
      render :edit, notice: "User can't be updated."
    end
  end

  def dashboard
    @menu_highlighted = :home
  end

  def deactivate
    if @user.try(:deactivate)
      redirect_to users_path
    else
      redirect_to user_url(@user)
    end
  end

  def activate
    if @user.try(:activate)
      redirect_to users_path
    else
      redirect_to user_url(@user)
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: 'User succesfully deleted.'
    else
      redirect_to users_path, notice: "There was an error and user can't be deleted."
    end
  end

  private

    def set_current_user
      @user = current_user
    end

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit!
    end

    def menu_highlight
      @menu_highlighted = :users
    end
end
