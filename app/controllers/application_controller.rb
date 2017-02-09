# frozen_string_literal: true
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :menu_highlight
  before_action :set_locale, unless: -> { request.xhr? }
  before_action :get_locale
  after_action  :store_location

  def default_url_options(options={})
    { locale: I18n.locale }
  end

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  protected

    def configure_permitted_parameters
      added_attrs = [:username, :email, :name, :institution, :permissions_request, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    def store_location
      return unless request.get?
      if request.fullpath.match('/account/login') &&
        request.fullpath.match('/account/register') &&
        request.fullpath.match('/account/secret/new') &&
        request.fullpath.match('/account/secret/edit') &&
        request.fullpath.match('/account/logout') &&
        request.fullpath.match('/account/edit') &&
        request.fullpath.match('/account/password') &&
        request.fullpath.match('/account/cancel') &&
        !request.xhr? # don't store ajax calls
        session[:previous_url] = request.fullpath
      end
    end

    def after_sign_in_path_for(*)
      session[:previous_url] || dashboard_url
    end

    def menu_highlight
      @menu_highlighted = :none
    end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def get_locale
      gon.current_locale = I18n.locale
    end
end
