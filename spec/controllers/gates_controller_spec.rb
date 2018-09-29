require 'rails_helper'

RSpec.describe GatesController, type: :controller do
  let(:stadium) { create(:stadium) }
  let(:valid_attributes) { attributes_for(:gate, stadium_id: stadium.id) }
  let(:invalid_attributes) { attributes_for(:gate, code: '') }
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
    let(:gate) { Gate.create!(valid_attributes) }

    it 'returns a success response' do
      get :show, params: { id: gate.to_param }.merge(default_params)
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
    let(:gate) { Gate.create!(valid_attributes) }

    it 'returns a success response' do
      get :edit, params: { id: gate.to_param }.merge(default_params)
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    let(:action) { post :create, params: { gate: attributes }.merge(default_params) }

    context 'with valid params' do
      let(:attributes) { valid_attributes }

      it 'creates a new Gate' do
        expect { action }.to change(Gate, :count).by(1)
      end

      it 'redirects to the created gate' do
        action
        expect(response).to redirect_to(stadium_gates_path(stadium))
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
    let!(:gate) { Gate.create!(valid_attributes) }
    let(:action) { put :update, params: { id: gate.to_param, gate: attributes }.merge(default_params) }

    context 'with valid params' do
      let(:attributes) { { code: 'updated code' } }

      it 'updates the requested gate' do
        action
        gate.reload
        expect(gate.code).to eq('UPDATED CODE')
      end

      it 'redirects to the gate' do
        action
        expect(response).to redirect_to(stadium_gates_path(stadium))
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
    let!(:gate) { Gate.create!(valid_attributes) }
    let(:action) { delete :destroy, params: { id: gate.to_param }.merge(default_params) }

    it 'destroys the requested gate' do
      expect { action }.to change(Gate, :count).by(-1)
    end

    it 'redirects to the gates list' do
      action
      expect(response).to redirect_to(stadium_gates_path(stadium))
    end
  end
end
