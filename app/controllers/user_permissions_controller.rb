# frozen_string_literal: true
class UserPermissionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_user
  before_action :set_permission
  before_action :set_selection

  def show; end

  def edit; end

  def update
    if @user.user_permission.update(permissions_params)
      redirect_to user_url(@user), notice: 'User permissions updated.'
    else
      render :edit, notice: "User permissions can't be updated."
    end
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_permission
      @permission = UserPermission.find(params[:id])
    end

    def set_selection
      @roles = ['user', 'operator', 'ngo', 'admin']
    end

    def permissions_params
      params.require(:user_permission).permit(:user_id, :user_role, :permissions)
    end

    def menu_highlight
      @menu_highlighted = :users
    end
end
