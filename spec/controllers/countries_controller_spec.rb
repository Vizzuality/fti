require 'rails_helper'

RSpec.describe CountriesController, type: :controller do
  before :each do
    @country = create(:country)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { name: 'New country', iso: 'NCA' }
  end

  let!(:attri_fail) do
    { name: '', iso: '' }
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
      post :create, params: { country: attri }
      expect(response).to          be_redirect
      expect(response).to          have_http_status(302)
      expect(Country.last.name).to eq('New country')
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @country.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update country' do
      put :update, params: { id: @country.id, country: attri }
      expect(response).to          be_redirect
      expect(response).to          have_http_status(302)
      expect(Country.last.name).to eq('New country')
    end

    context 'allows to delete not relationed country' do
      let!(:country) { create(:country, name: 'Acountry', iso: 'ACC') }
      it 'delete country' do
        delete :destroy, params: { id: country.id }
        expect(response).to         be_redirect
        expect(response).to         have_http_status(302)
        expect(response).to         redirect_to(countries_path)
        expect(Country.where(name: 'Acountry')).to eq([])
      end
    end

    render_views

    it 'User should not be able to update country without name' do
      put :update, params: { id: @country.id, country: attri_fail }
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
