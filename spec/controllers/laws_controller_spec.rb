require 'rails_helper'

RSpec.describe LawsController, type: :controller do
  before :each do
    @law = create(:law)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { legal_reference: 'New law' }
  end

  let!(:attri_fail) do
    { legal_reference: '' }
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
      post :create, params: { law: attri }
      expect(response).to                 be_redirect
      expect(response).to                 have_http_status(302)
      expect(Law.last.legal_reference).to eq('New law')
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @law.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update law' do
      put :update, params: { id: @law.id, law: attri }
      expect(response).to                 be_redirect
      expect(response).to                 have_http_status(302)
      expect(Law.last.legal_reference).to eq('New law')
    end

    context 'allows to delete not relationed law' do
      let!(:law) { create(:law, legal_reference: 'Alaw') }
      it 'delete law' do
        delete :destroy, params: { id: law.id }
        expect(response).to be_redirect
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(laws_path)
        expect(Law.where(legal_reference: 'Alaw')).to eq([])
      end
    end

    render_views

    it 'User should not be able to update law without legal_reference' do
      put :update, params: { id: @law.id, law: attri_fail }
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
