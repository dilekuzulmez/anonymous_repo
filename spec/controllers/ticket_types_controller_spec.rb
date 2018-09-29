require 'rails_helper'

RSpec.describe TicketTypesController, type: :controller do
  let(:admin) { create(:admin) }
  let(:match) { create(:match) }
  let(:root_params) { { match_id: match.id } }
  let(:create_ticket_type) { TicketType.create!(valid_attributes.merge(match_id: match.id)) }
  let(:after_change_redirect) { match_ticket_types_path(match) }

  let(:valid_attributes) do
    attributes_for(:ticket_type, code: 'VALID_CODE', price: 10.0, quantity: 100)
  end

  let(:invalid_attributes) do
    attributes_for(:ticket_type, code: '')
  end

  before { sign_in admin }

  describe 'GET #index' do
    it 'returns a success response' do
      create_ticket_type
      get :index, params: root_params
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      ticket_type = create_ticket_type
      get :show, params: { id: ticket_type.to_param }.merge(root_params)
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: root_params
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      ticket_type = create_ticket_type
      get :edit, params: { id: ticket_type.to_param }.merge(root_params)
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    let(:action) { post :create, params: { ticket_type: attributes }.merge(root_params) }

    context 'with valid params' do
      let(:attributes) { valid_attributes }

      it 'creates a new TicketType' do
        expect { action }.to change(TicketType, :count).by(1)
      end

      it 'redirects to the created ticket_type' do
        action
        expect(response).to redirect_to(after_change_redirect)
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
    let(:ticket_type) { create_ticket_type }
    let(:action) do
      put :update, params: { id: ticket_type.id, ticket_type: attributes }.merge(root_params)
    end

    context 'with valid params' do
      let(:attributes) { valid_attributes.merge(price: 200_000) }

      it 'updates the requested ticket_type' do
        action
        ticket_type.reload
        expect(ticket_type.price).to eq(200_000)
      end

      it 'redirects to the ticket_type' do
        action
        expect(response).to redirect_to(after_change_redirect)
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
    let!(:ticket_type) { create_ticket_type }
    let(:action) { delete :destroy, params: { id: ticket_type.id }.merge(root_params) }

    it 'destroys the requested ticket_type' do
      expect { action }.to change(TicketType, :count).by(-1)
    end

    it 'redirects to the ticket_types list' do
      action
      expect(response).to redirect_to(after_change_redirect)
    end
  end
end
