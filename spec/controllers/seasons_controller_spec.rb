require 'rails_helper'

def convert_attributes(attributes)
  new_attributes = attributes.dup
  duration = new_attributes.delete(:duration)

  if duration
    new_attributes[:duration_start] = duration.first
    new_attributes[:duration_end] = duration.last
  end

  teams = new_attributes.delete(:teams)
  new_attributes[:team_ids] = teams.map(&:id)
  new_attributes
end

RSpec.describe SeasonsController, type: :controller do
  let!(:season_discount) { create(:loyalty_point_rule, code: 'SEASON_DISCOUNT') }
  let!(:league) { create(:league) }
  let(:valid_attributes) do
    attributes_for(:season, league_id: league.id)
  end

  let(:invalid_attributes) do
    attributes_for(:season, duration: nil)
  end

  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe 'GET #index' do
    it 'returns a success response' do
      Season.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      season = Season.create! valid_attributes
      get :show, params: { id: season.to_param }
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
    it 'returns a success response' do
      season = Season.create! valid_attributes
      get :edit, params: { id: season.to_param }
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    let(:action) { post :create, params: { season: convert_attributes(attributes) } }

    context 'with valid params' do
      let(:attributes) { valid_attributes }

      it 'creates a new Season' do
        expect { action }.to change(Season, :count).by(1)
      end

      it 'redirects to the created season' do
        action
        expect(response).to redirect_to(seasons_path)
      end
    end

    context 'with invalid params' do
      let(:attributes) { invalid_attributes }

      it "returns a success response (i.e. to display the 'new' template)" do
        action
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    let(:season) { create(:season) }

    context 'with valid params' do
      let(:new_attributes) { {  name: 'new name' } }
      let(:action) { put :update, params: { id: season.to_param, season: new_attributes } }

      it 'updates the requested season' do
        action
        season.reload
        expect(season.name).to eq('new name')
      end

      it 'redirects to the season' do
        action
        expect(response).to redirect_to(seasons_path)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { duration: nil } }
      let(:params) { { id: season.to_param, season: convert_attributes(invalid_attributes) } }
      let(:action) { put :update, params: params }

      it "returns a success response (i.e. to display the 'edit' template)" do
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested season' do
      season = Season.create! valid_attributes
      expect do
        delete :destroy, params: { id: season.to_param }
      end.to change(Season, :count).by(-1)
    end

    it 'redirects to the seasons list' do
      season = Season.create! valid_attributes
      delete :destroy, params: { id: season.to_param }
      expect(response).to redirect_to(seasons_url)
    end
  end
end
