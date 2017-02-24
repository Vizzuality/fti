require 'rails_helper'

RSpec.describe AnnexGovernancesController, type: :controller do
  before :each do
    @annex_governance = create(:annex_governance)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { governance_pillar: 'New annex_governance', governance_problem: 'New annex_governance problem' }
  end

  let!(:attri_fail) do
    { governance_pillar: '', governance_problem: 'New annex_governance problem' }
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
      post :create, params: { annex_governance: attri }
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
      expect(AnnexGovernance.last.governance_pillar).to eq('New annex_governance')
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @annex_governance.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update annex_governance' do
      put :update, params: { id: @annex_governance.id, annex_governance: attri }
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
      expect(AnnexGovernance.last.governance_pillar).to eq('New annex_governance')
    end

    context 'allows to delete not relationed annex_governance' do
      let!(:annex_governance) { create(:annex_governance, governance_pillar: 'Aannex_governance', governance_problem: 'Aannex_governance problem') }
      it 'delete annex_governance' do
        delete :destroy, params: { id: annex_governance.id }
        expect(response).to be_redirect
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(annex_governances_path)
        expect(AnnexGovernance.where(governance_pillar: 'Aannex_governance')).to eq([])
      end
    end

    render_views

    it 'User should not be able to update annex_governance without governance_pillar' do
      put :update, params: { id: @annex_governance.id, annex_governance: attri_fail }
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
