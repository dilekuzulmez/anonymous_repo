require 'rails_helper'
RSpec.describe PromotionsController, type: :controller do
  let(:valid_attributes) { attributes_for(:promotion) }
  let(:invalid_attributes) { attributes_for(:promotion, code: '') }
  let(:admin) { create(:admin) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'returns a success response' do
      Promotion.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      promotion = Promotion.create! valid_attributes
      get :show, params: { id: promotion.to_param }
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
      promotion = Promotion.create! valid_attributes
      get :edit, params: { id: promotion.to_param }
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Promotion' do
        expect do
          post :create, params: { promotion: valid_attributes }
        end.to change(Promotion, :count).by(1)
      end

      it 'redirects to the created promotion' do
        post :create, params: { promotion: valid_attributes }
        expect(response).to redirect_to(promotions_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { promotion: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { valid_attributes.merge(description: 'test description') }

      it 'updates the requested promotion' do
        promotion = Promotion.create! valid_attributes
        put :update, params: { id: promotion.to_param, promotion: new_attributes }
        promotion.reload
        expect(promotion.description).to eq('test description')
      end

      it 'redirects to the promotion' do
        promotion = Promotion.create! valid_attributes
        put :update, params: { id: promotion.to_param, promotion: valid_attributes }
        expect(response).to redirect_to(promotions_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        promotion = Promotion.create! valid_attributes
        put :update, params: { id: promotion.to_param, promotion: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested promotion' do
      promotion = Promotion.create! valid_attributes
      expect do
        delete :destroy, params: { id: promotion.to_param }
      end.to change(Promotion, :count).by(-1)
    end

    it 'redirects to the promotions list' do
      promotion = Promotion.create! valid_attributes
      delete :destroy, params: { id: promotion.to_param }
      expect(response).to redirect_to(promotions_url)
    end
  end

  describe 'GET find' do
    let!(:promotion) { create(:promotion, :active, code: 'abc') }
    let!(:match) { create(:match) }
    let!(:matchs_promotion) { create(:matchs_promotion, match: match, promotion: promotion) }
    let!(:customer) { create(:customer) }
    let(:action) { get :find, params: { code: code, match_id: match.id, customer_id: customer.id } }

    context 'valid promo code' do
      let(:code) { 'abc' }

      it 'returns http success' do
        action
        expect(response).to be_success
      end

      it 'renders promotion as json' do
        action
        expect(response.body).to eq(promotion.to_json)
      end
    end

    context 'invalid promo code' do
      let(:code) { 'def' }

      it 'returns bad request' do
        action
        expect(response.status).to eq(400)
      end
    end
  end
end
