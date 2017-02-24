# frozen_string_literal: true
Rails.application.routes.draw do
  scope '(:locale)', locale: /en|fr/ do
    devise_for :users, path: 'account',
                       path_names: {
                         sign_in: 'login', sign_out: 'logout',
                         password: 'secret', sign_up: 'register'
                       },
                       controllers: {
                         sessions: 'users/sessions',
                         registrations: 'users/registrations',
                         passwords: 'users/passwords'
                       }

    scope :account do
      devise_scope :user do
        post 'register',  to: 'users/registrations#create', as: :register
        post 'password',  to: 'users/passwords#create',     as: :secret
        post 'edit',      to: 'users/registrations#edit',   as: :account_edit
      end
    end

    scope :manage do
      resources :users, except: [:new, :create] do
        patch 'deactivate', on: :member
        patch 'activate',   on: :member
        resources :user_permissions, only: [:show, :edit, :update], on: :member, as: :permission
      end

      resources :countries
      resources :categories
      resources :species
      resources :operators
      resources :laws
      resources :governments
      resources :observers, path: 'monitors', as: :monitors
      resources :observations, except: [:new, :create, :validate_observation]

      resource :observations, path: 'observations/new', except: [:index, :show, :edit, :update, :destroy, :new] do
        get  :types
        get  :info
        get  :attachments
        post :validate_observation
      end
    end

    get 'dashboard', to: 'users#dashboard', as: :dashboard

    root to: 'home#show'
  end
end
