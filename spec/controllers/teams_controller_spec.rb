require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
    allow_any_instance_of(Paperclip::Attachment).to receive(:save).and_return(true)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      team = create(:team)
      get :show, params: { id: team.slug }
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    let!(:team) { create(:team) }

    it 'returns a success response' do
      get :edit, params: { id: team.slug }
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    let(:team_attributes) { attributes_for(:team) }
    let(:banner) { "#{Rails.root}/spec/fixtures/sample_banner.png" }
    let(:action) { post :create, params: { team: team_attributes, banner: banner } }

    context 'with valid params' do
      it 'creates a new Team' do
        expect { action }.to change(Team, :count).by(1)
      end

      it 'redirects to teams index' do
        action
        expect(response).to redirect_to(teams_path)
      end
    end

    context 'with invalid params' do
      let(:team_attributes) { attributes_for(:team, name: '') }

      it "returns a success response (i.e. to display the 'new' template)" do
        action
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    let!(:team) { create(:team) }
    let(:new_banner) { "#{Rails.root}/spec/fixtures/sample_banner_2.png" }
    let(:action) { put :update, params: { id: team.id, team: new_attributes, banner: new_banner } }

    context 'with valid params' do
      let(:new_attributes) { { name: 'Updated Name', description: 'Updated description' } }

      it 'updates the requested team' do
        action
        team.reload
        expect(team.name).to eq('Updated Name')
      end

      it 'redirects to the teams index' do
        action
        expect(response).to redirect_to(teams_path)
      end
    end

    context 'with invalid params' do
      let(:new_attributes) { { name: '' } }

      it "returns a success response (i.e. to display the 'edit' template)" do
        action
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:team) { create(:team) }
    let(:action) { delete :destroy, params: { id: team.slug } }

    it 'destroys the requested team' do
      expect { action }.to change(Team, :count).by(-1)
    end

    it 'redirects to the teams list' do
      action
      expect(response).to redirect_to(teams_url)
    end
  end

  describe 'GET #home_stadium' do
    let!(:team) { create(:team) }
    let(:params) { { id: team.id } }
    let(:action) { get :home_stadium, format: :json, params: params }

    it 'returns json for stadium' do
      action
      body = JSON.parse(response.body)
      expect(body['id']).to eq(team.home_stadium.id)
      expect(body['name']).to eq(team.home_stadium.name)
    end
  end
end
