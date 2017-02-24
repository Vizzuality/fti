require 'rails_helper'

RSpec.describe OperatorsController, type: :controller do
  before :each do
    @operator = create(:operator)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { name: 'New operator' }
  end

  let!(:attri_fail) do
    { name: '' }
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
      post :create, params: { operator: attri }
      expect(response).to           be_redirect
      expect(response).to           have_http_status(302)
      expect(Operator.last.name).to eq('New operator')
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @operator.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update operator' do
      put :update, params: { id: @operator.id, operator: attri }
      expect(response).to           be_redirect
      expect(response).to           have_http_status(302)
      expect(Operator.last.name).to eq('New operator')
    end

    context 'allows to delete not relationed operator' do
      let!(:operator) { create(:operator, name: 'Aoperator') }
      it 'delete operator' do
        delete :destroy, params: { id: operator.id }
        expect(response).to         be_redirect
        expect(response).to         have_http_status(302)
        expect(response).to         redirect_to(operators_path)
        expect(Operator.where(name: 'Aoperator')).to eq([])
      end
    end

    render_views

    it 'User should not be able to update operator without name' do
      put :update, params: { id: @operator.id, operator: attri_fail }
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
