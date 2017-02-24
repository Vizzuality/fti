require 'rails_helper'

RSpec.describe SpeciesController, type: :controller do
  before :each do
    @species = create(:species)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { name: 'New species', common_name: 'NCA' }
  end

  let!(:attri_fail) do
    { name: '', common_name: '' }
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
      post :create, params: { species: attri }
      expect(response).to          be_redirect
      expect(response).to          have_http_status(302)
      expect(Species.last.name).to eq('New species')
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @species.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update species' do
      put :update, params: { id: @species.id, species: attri }
      expect(response).to          be_redirect
      expect(response).to          have_http_status(302)
      expect(Species.last.name).to eq('New species')
    end

    context 'allows to delete not relationed species' do
      let!(:species) { create(:species, name: 'Aspecies', common_name: 'ACC') }
      it 'delete species' do
        delete :destroy, params: { id: species.id }
        expect(response).to         be_redirect
        expect(response).to         have_http_status(302)
        expect(response).to         redirect_to(species_index_path)
        expect(Species.where(name: 'Aspecies')).to eq([])
      end
    end

    render_views

    it 'User should not be able to update species without name' do
      put :update, params: { id: @species.id, species: attri_fail }
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
