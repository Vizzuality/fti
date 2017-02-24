require 'rails_helper'

RSpec.describe ObserversController, type: :controller do
  before :each do
    @observer = create(:observer)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { name: 'New observer', observer_type: 'External' }
  end

  let!(:attri_fail) do
    { name: '', observer_type: 'External' }
  end

  context 'For authenticated adminuser' do
    before :each do
      sign_in @adminuser
    end

    it 'GET index returns http success' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'GET new returns http success' do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'GET create returns http success' do
      post :create, params: { observer: attri }
      expect(response).to           be_redirect
      expect(response).to           have_http_status(302)
      expect(Observer.last.name).to eq('New observer')
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @observer.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update observer' do
      put :update, params: { id: @observer.id, observer: attri }
      expect(response).to           be_redirect
      expect(response).to           have_http_status(302)
      expect(Observer.last.name).to eq('New observer')
    end

    context 'allows to delete not relationed observer' do
      let!(:observer) { create(:observer, name: 'Aobserver') }
      it 'delete observer' do
        delete :destroy, params: { id: observer.id }
        expect(response).to         be_redirect
        expect(response).to         have_http_status(302)
        expect(response).to         redirect_to(monitors_path)
        expect(Observer.where(name: 'Aobserver')).to eq([])
      end
    end

    render_views

    it 'User should not be able to update observer without name' do
      put :update, params: { id: @observer.id, observer: attri_fail }
      expect(response.body).to match('<small class="error">can&#39;t be blank</small>')
    end
  end

  context 'Users' do
    it 'GET index returns http redirect for non logged user' do
      get :index
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
    end
  end
end
