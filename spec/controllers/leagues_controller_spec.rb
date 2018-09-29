require 'rails_helper'

RSpec.describe LeaguesController, type: :controller do
  let!(:admin) { create(:admin) }
  let!(:leagues) { create_list(:league, 2) }

  describe 'get without sign in' do
    it 'return 302' do
      get :index, params: {}
      expect(response.status).to eq(302)
      expect(request.path).to eq('/unauthenticated')
    end
  end

  describe 'get #index league' do
    it 'return 200 and return 2 leagues' do
      sign_in admin
      get :index, params: {}
      expect(response.status).to eq(200)
      expect(leagues.count).to eq(2)
    end
  end

  describe 'get #show league' do
    before do
      sign_in admin
    end
    it 'return 200 if valid params' do
      get :show, params: { id: leagues.first.slug }
      expect(response.status).to eq(200)
    end

    it 'return 302 if invalid params' do
      get :show, params: { id: "I'm invalid" }
      expect(response.status).to eq(302)
      expect(controller).to set_flash[:danger]
    end
  end

  describe 'get #edit league' do
    before do
      sign_in admin
    end
    it 'return 200 if valid params' do
      get :edit, params: { id: leagues.first.slug }
      expect(response).to be_success
    end

    it 'return 302 if invalid params' do
      get :edit, params: { id: leagues.first.id + 999 }
      expect(response).to be_redirect
    end
  end

  describe 'post #create league' do
    before do
      sign_in admin
    end
    let(:action) { post :create, params: { league: league_attributes } }
    let(:league_attributes) { { name: 'league', code: 'LEA' } }

    context 'with valid params' do
      it 'creates a new league' do
        expect { action }.to change(League, :count).by(1)
        expect(League.count).to eq(3)
        expect(response).to redirect_to(leagues_path)
      end
    end

    context 'with invalid params' do
      let(:league_attributes) { { name: '', code: '' } }

      it 'returns a success response' do
        action
        expect(response).to be_success
        expect(League.count).to eq(2)
      end
    end

    context 'with existed params' do
      let(:league_attributes) { { name: League.first.name, code: League.first.code } }

      it 'returns a success response' do
        action
        expect(response).to be_success
        expect(League.count).to eq(2)
        expect(response.body).to include('has already been taken')
      end
    end
  end

  describe 'patch #update league' do
    let(:league) { create(:league) }

    before do
      sign_in admin
      action
    end
    context 'with valid params' do
      let(:action) { patch :update, params: { id: league.id, league: new_attributes } }
      let(:new_attributes) { { name: 'updated' } }

      it 'return leagues path if valid params' do
        league.reload
        expect(league.name).to eq('updated')
        expect(response).to redirect_to(leagues_path)
      end

      it 'redirects to the leagues index' do
        expect(response).to redirect_to(leagues_path)
      end
    end
    context 'with invalid params' do
      let(:action) { patch :update, params: { id: league.id, league: new_attributes } }
      let(:new_attributes) { { name: '' } }

      it 'return 200 and render edit if invalid params' do
        expect(response.status).to eq(200)
      end
    end
  end
end
