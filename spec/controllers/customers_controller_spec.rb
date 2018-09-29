require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let(:admin) { create(:admin) }

  let(:valid_attributes) do
    attributes_for(:customer)
  end

  let(:invalid_attributes) do
    attributes_for(:customer, email: '')
  end

  before { sign_in admin }

  describe 'GET #index' do
    it 'returns a success response' do
      Customer.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      customer = Customer.create! valid_attributes
      get :show, params: { id: customer.to_param }
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
      customer = Customer.create! valid_attributes
      get :edit, params: { id: customer.to_param }
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Customer' do
        expect do
          post :create, params: { customer: valid_attributes }
        end.to change(Customer, :count).by(1)
      end

      it 'redirects to the created customer' do
        post :create, params: { customer: valid_attributes }
        expect(response).to redirect_to(customers_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { customer: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { first_name: 'John', last_name: 'Doe' } }

      it 'updates the requested customer' do
        customer = Customer.create! valid_attributes
        put :update, params: { id: customer.to_param, customer: new_attributes }
        customer.reload
        expect(customer.first_name).to eq('John')
        expect(customer.last_name).to eq('Doe')
      end

      it 'redirects to the customer' do
        customer = Customer.create! valid_attributes
        put :update, params: { id: customer.to_param, customer: valid_attributes }
        expect(response).to redirect_to(customers_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        customer = Customer.create! valid_attributes
        put :update, params: { id: customer.to_param, customer: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested customer' do
      customer = Customer.create! valid_attributes
      expect do
        delete :destroy, params: { id: customer.to_param }
      end.to change(Customer, :count).by(-1)
    end

    it 'redirects to the customers list' do
      customer = Customer.create! valid_attributes
      delete :destroy, params: { id: customer.to_param }
      expect(response).to redirect_to(customers_url)
    end
  end

  describe 'POST #bulk_create' do
    let(:file_path) { File.open("#{Rails.root}/spec/fixtures/sample_matches.csv") }
    let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path) }
    let(:action) { post :bulk_create, params: { file: uploaded_file } }
    let(:object) { Object.new }
    let(:message) { 'Success' }

    before do
      allow(ImportCustomerService).to receive(:new).and_return(object)
      allow(object).to receive(:execute).and_return(message)
    end

    it 'redirects to index path' do
      action
      expect(response).to redirect_to(import_customers_path)
    end
  end
end
