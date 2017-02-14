require 'rails_helper'

RSpec.describe UserPermissionsController, type: :controller do
  before :each do
    @user = create(:user, name: 'Testuser')
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { user_permission: { user_role: 'ngo', permissions: {"user"=>{"id"=>["manage"]}}}}
  end

  let!(:attri_failed) do
    { user_permission: { user_role: 'admin', permissions: ['test']}}
  end

  context 'For authenticated adminuser' do
    before :each do
      sign_in @adminuser
    end

    it 'GET show returns http success' do
      get :show, params: { id: @user.user_permission.id, user_id: @user.id, on: :member }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @user.user_permission.id, user_id: @user.id, on: :member }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update user' do
      put :update, params: { id: @user.user_permission.id, user_id: @user.id, on: :member }.merge(attri)
      expect(response).to                            be_redirect
      expect(response).to                            have_http_status(302)
      expect(User.find_by(name: 'Testuser').ngo?).to eq(true)
    end

    it 'failed to update user' do
      put :update, params: { id: @user.user_permission.id, user_id: @user.id, on: :member }.merge(attri_failed)
      expect(response).to                            be_redirect
      expect(response).to                            have_http_status(302)
      expect(User.find_by(name: 'Testuser').ngo?).to eq(false)
    end
  end
end
