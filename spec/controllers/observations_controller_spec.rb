require 'rails_helper'

RSpec.describe ObservationsController, type: :controller do
  before :each do
    @observation = create(:observation_1)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { publication_date: DateTime.now.to_date  }
  end

  let!(:attri_fail) do
    { publication_date: '' }
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

    it 'GET edit returns http success' do
      get :edit, params: { id: @observation.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update observation' do
      put :update, params: { id: @observation.id, observation: attri }
      expect(response).to                 be_redirect
      expect(response).to                 have_http_status(302)
      expect(Law.last.legal_reference).to eq('Lorem')
    end

    it 'delete observation' do
      delete :destroy, params: { id: @observation.id }
      expect(response).to          be_redirect
      expect(response).to          have_http_status(302)
      expect(response).to          redirect_to(observations_path)
      expect(Observation.count).to eq(0)
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
