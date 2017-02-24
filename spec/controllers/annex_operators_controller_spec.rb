require 'rails_helper'

RSpec.describe AnnexOperatorsController, type: :controller do
  before :each do
    @annex_operator = create(:annex_operator)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { illegality: 'New annex_operator' }
  end

  let!(:attri_fail) do
    { illegality: '' }
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
      post :create, params: { annex_operator: attri }
      expect(response).to                      be_redirect
      expect(response).to                      have_http_status(302)
      expect(AnnexOperator.last.illegality).to eq('New annex_operator')
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @annex_operator.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update annex_operator' do
      put :update, params: { id: @annex_operator.id, annex_operator: attri }
      expect(response).to                      be_redirect
      expect(response).to                      have_http_status(302)
      expect(AnnexOperator.last.illegality).to eq('New annex_operator')
    end

    context 'allows to delete not relationed annex_operator' do
      let!(:annex_operator) { create(:annex_operator, illegality: 'Aannex_operator') }
      it 'delete annex_operator' do
        delete :destroy, params: { id: annex_operator.id }
        expect(response).to be_redirect
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(annex_operators_path)
        expect(AnnexOperator.where(illegality: 'Aannex_operator')).to eq([])
      end
    end

    render_views

    it 'User should not be able to update annex_operator without illegality' do
      put :update, params: { id: @annex_operator.id, annex_operator: attri_fail }
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
