require 'rails_helper'

RSpec.describe ZonesController, type: :controller do
  let(:stadium) { create(:stadium) }
  let(:gate) { create(:gate) }
  let(:valid_attributes) { attributes_for(:zone, stadium_id: stadium.id, gate_id: gate.id) }
  let(:invalid_attributes) { attributes_for(:zone, code: '', price: '') }
  let(:default_params) { { stadium_id: stadium.id } }
  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: default_params
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:zone) { Zone.create!(valid_attributes) }

    it 'returns a success response' do
      get :show, params: { id: zone.to_param }.merge(default_params)
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: default_params
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    let(:zone) { Zone.create!(valid_attributes) }

    it 'returns a success response' do
      get :edit, params: { id: zone.to_param }.merge(default_params)
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    let(:action) { post :create, params: { zone: attributes }.merge(default_params) }

    context 'with valid params' do
      let(:attributes) { valid_attributes }

      it 'creates a new Zone' do
        expect { action }.to change(Zone, :count).by(1)
      end

      it 'redirects to the created zone' do
        action
        expect(response).to redirect_to(stadium_zones_path(stadium))
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
    let!(:zone) { Zone.create!(valid_attributes) }
    let(:action) { put :update, params: { id: zone.to_param, zone: attributes }.merge(default_params) }

    context 'with valid params' do
      let(:attributes) { { code: 'updated code', capacity: 10, price: 100.00 } }

      it 'updates the requested zone' do
        action
        zone.reload
        expect(zone.capacity).to eq(10)
        expect(zone.price).to eq(100.00)
        expect(zone.code).to eq('UPDATED CODE')
      end

      it 'redirects to the zone' do
        action
        expect(response).to redirect_to(stadium_zones_path(stadium))
      end
    end

    context 'with invalid params' do
      let(:attributes) { invalid_attributes }

      it "returns a success response (i.e. to display the 'edit' template)" do
        action
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:zone) { Zone.create!(valid_attributes) }
    let(:action) { delete :destroy, params: { id: zone.to_param }.merge(default_params) }

    it 'destroys the requested zone' do
      expect { action }.to change(Zone, :count).by(-1)
    end

    it 'redirects to the zones list' do
      action
      expect(response).to redirect_to(stadium_zones_path(stadium))
    end
  end
end
