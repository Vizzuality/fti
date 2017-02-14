require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before :each do
    @user      = create(:user)
    @user_2    = create(:user, active: false)
    @user_3    = create(:user)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { name: 'New first' }
  end

  let!(:attri_fail) do
    { email: '', username: 'testuser' }
  end

  context 'For authenticated adminuser' do
    before :each do
      sign_in @adminuser
    end

    it 'GET dashboard_path returns http success' do
      get :dashboard
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'GET index returns http success' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'GET show returns http success' do
      get :show, params: { id: @user.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @user.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update user' do
      put :update, params: { id: @user.id, user: attri }
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
    end

    it 'delete user' do
      delete :destroy, params: { id: @user.id }
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
    end

    render_views

    it 'User should not be able to update user without email' do
      put :update, params: { id: @user.id, user: attri_fail }
      expect(response.body).to match('<small class="error">can&#39;t be blank</small>')
    end
  end

  context 'Users' do
    it 'GET index returns http redirect for non logged in user' do
      get :index
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
    end

    it 'GET show returns http redirect for non logged in user' do
      get :show, params: { id: @user.id }
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
    end
  end

  context 'AdminUser should be able to activate and deactivate user' do
    before :each do
      sign_in @adminuser
    end

    it 'Activate user' do
      patch :activate, params: { id: @user_2.id }
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
    end

    it 'Deactivate user' do
      patch :deactivate, params: { id: @user.id }
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
    end
  end
end
