require 'rails_helper'

RSpec.describe ObservationsStepsController, type: :controller do

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

    it 'GET new redirects to type' do
      get :new
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
    end
  end

  context 'Users' do
    it 'GET new returns http redirect for non logged user' do
      get :new
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
    end
  end

end