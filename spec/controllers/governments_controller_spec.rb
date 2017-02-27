require 'rails_helper'

RSpec.describe GovernmentsController, type: :controller do
  before :each do
    @government = create(:government)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { government_entity: 'New government' }
  end

  let!(:attri_fail) do
    { government_entity: '' }
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
      post :create, params: { government: attri }
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
      expect(Government.last.government_entity).to eq('New government')
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @government.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update government' do
      put :update, params: { id: @government.id, government: attri }
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
      expect(Government.last.government_entity).to eq('New government')
    end

    context 'allows to delete not relationed government' do
      let!(:government) { create(:government, government_entity: 'Agovernment') }
      it 'delete government' do
        delete :destroy, params: { id: government.id }
        expect(response).to be_redirect
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(governments_path)
        expect(Government.where(government_entity: 'Agovernment')).to eq([])
      end
    end

    render_views

    it 'User should not be able to update government without government_entity' do
      put :update, params: { id: @government.id, government: attri_fail }
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
