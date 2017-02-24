require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  before :each do
    @categories = create(:category)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:attri) do
    { name: 'New category' }
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
      post :create, params: { category: attri }
      expect(response).to           be_redirect
      expect(response).to           have_http_status(302)
      expect(Category.last.name).to eq('New category')
    end

    it 'GET edit returns http success' do
      get :edit, params: { id: @categories.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'update category' do
      put :update, params: { id: @categories.id, category: attri }
      expect(response).to           be_redirect
      expect(response).to           have_http_status(302)
      expect(Category.last.name).to eq('New category')
    end

    context 'allows to delete not relationed category' do
      let!(:category) { create(:category, name: 'Acategory') }
      it 'delete category' do
        delete :destroy, params: { id: category.id }
        expect(response).to         be_redirect
        expect(response).to         have_http_status(302)
        expect(response).to         redirect_to(categories_path)
        expect(Category.where(name: 'Acategory')).to eq([])
      end
    end

    render_views

    it 'User should not be able to update category without name' do
      put :update, params: { id: @categories.id, category: attri_fail }
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
