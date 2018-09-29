require 'rails_helper'

RSpec.describe CombosController, type: :controller do
  let(:admin) { create(:admin) }
  let!(:matches) { create_list(:match, 2) }
  let(:combo) do
    create(:combo, code: 'VBA', match_ids: [matches.first.id, matches.second.id],
                   price: 50_000, ticket_type: 'TYPE')
  end
  let!(:combos) { create_list(:combo, 3) }

  before { sign_in admin }

  describe 'get #index' do
    it 'return 3 combos' do
      get :index
      expect(response.status).to eq(200)
      expect(Combo.count).to eq(3)
    end
  end

  describe 'get #show' do
    it 'return code of specified combo' do
      get :show, params: { id: combo.id }
      expect(response.status).to eq(200)
      expect(response.body).to include(combo.code)
    end
  end

  describe 'post #create' do
    let(:action) do
      post :create, params: { combo: { code: 'A', match_ids: [matches.first.id, matches.second.id],
                                       price: 50_000, ticket_type: 'TYPE' } }
    end

    it 'create a record' do
      expect { action }.to change(Combo, :count).by(1)
    end
  end

  describe 'put #update' do
    let(:action) do
      put :update, params: { id: combo.id, combo: { code: 'UPDATED' } }
    end

    it 'updated a record' do
      action
      combo.reload
      expect(combo.code).to eq('UPDATED')
      expect(response.status).to redirect_to combo_path(combo)
    end
  end

  describe 'delete #destroy' do
    let(:action) do
      delete :destroy, params: { id: combo.id }
    end

    it 'destroy a record' do
      action
      expect(response.status).to redirect_to combos_path
      expect(Combo.count).to eq(3)
    end
  end
end
