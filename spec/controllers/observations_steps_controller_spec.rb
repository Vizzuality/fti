require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe ObservationsStepsController, type: :controller do
  before :each do
    @country             = create(:country)
    @annex_operator      = create(:annex_operator)
    @severity            = create(:severity, severable: @annex_operator)
    @pv                  = 'PV'
    @publication_date    = DateTime.now
    @concern_opinion     = 'opinion'
    @litigation_status   = 'status'
    @observer            = create(:observer)
    @operator            = create(:operator)
    @active              = true
    @details             = 'details'
    @evidence            = 'Evidence'
    @photo               = create(:photo)
  end

  let!(:adminuser) do
    adminuser = create(:admin)
    adminuser.user_permission.update(user_role: 'admin', permissions: {"admin"=>{"all"=>["read"]},"all"=>{"all"=>["manage"]}})
    @adminuser = User.last
  end

  let!(:first_step_params) do
    { observation_type: 'AnnexOperator', country_id: @country.id }
  end

  let!(:second_step_params) do
    { annex_operator_id:    @annex_operator.id,
      severity_id:          @severity.id,
      pv:                   @pv,
      publication_date:     @publication_date,
      concern_opinion:      @concern_opinion,
      litigation_status:    @litigation_status,
      observer_id:          @observer.id,
      operator_id:          @operator.id,
      active:               @active,
      details:              @details,
      evidence:             @evidence
    }
  end

  let!(:third_step_params) do
    { observation_photos_attributes: { name: 'Test photo',
                                       attachment: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files', 'image.png')) } }
  end

  context 'For authenticated adminuser' do
    before :each do
      sign_in @adminuser
    end

    it 'GET new observation' do
      get :new
      expect(response).to be_redirect
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(observations_step_path(Wicked::FIRST_STEP))
    end

    context 'First step - types' do
      it 'GET first step - types' do
        get :show, params: { id: 'types' }, session: { observation: {}}
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'PUT first step - types' do
        put :update, params: { id: 'types', observation: first_step_params }, session: { observation: {} }
        expect(response).to be_redirect
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(observations_step_path(:info))
      end

      it 'PUT first step - types - without params fails' do
        put :update, params: { id: 'types', observation: {} }, session: { observation: {} }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end

    context 'Second step - info' do
      it 'GET second step - info' do
        get :show, params: { id: 'info' }, session: { observation: first_step_params }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'PUT second step - info' do
        put :update, params: { id: 'info', observation: second_step_params }, session: { observation: first_step_params }
        expect(response).to be_redirect
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(observations_step_path(:attachments))
      end

      it 'PUT second step - without params fails' do
        put :update, params: { id: 'info', observation: {} }, session: { observation: first_step_params }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end

    context 'Third step - attachments' do
      it 'GET third step - attachements' do
        get :show, params: { id: 'attachments' }, session: { observation: first_step_params.merge!(second_step_params) }
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

     it 'PUT third step - attachments' do
       put :update, params: { id: 'attachments', observation: third_step_params },
                    session: { observation: first_step_params.merge!(second_step_params) }
       expect(response).to be_redirect
       expect(response).to have_http_status(302)
       expect(response).to redirect_to(observations_path)
     end
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