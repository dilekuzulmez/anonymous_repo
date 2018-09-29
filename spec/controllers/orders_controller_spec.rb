require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:admin) { create(:admin) }
  let!(:match) { create(:match) }
  let(:ticket_type) { create(:ticket_type, match: match, price: 100_000) }
  let(:phone) { '090-000-0001' }
  let(:normalized_phone) { '0900000001' }
  let!(:customer) do
    create(:customer,
           first_name: 'first',
           last_name: 'last',
           phone_number: phone,
           invitor_code: 'hello')
  end

  let(:order_params) do
    attributes_for(:order,
                   customer_id: customer.id,
                   status: :completed,
                   purchased_date: Time.zone.now,
                   paid: true).except(:order_details)
  end

  let(:order_detail) do
    attributes_for(:order_detail,
                   ticket_type_id: ticket_type.id,
                   unit_price: ticket_type.price,
                   quantity: 3,
                   match_id: match.id)
  end

  let(:valid_attributes) do
    order_attrs = order_params
    order_attrs['order_details_attributes'] = [order_detail]
    order_attrs
  end

  let(:invalid_order_detail) do
    attributes_for(:order_detail,
                   id: order.order_details.first.id,
                   ticket_type_id: ticket_type.id,
                   unit_price: ticket_type.price,
                   quantity: 3,
                   match_id: nil)
  end

  let(:invalid_attributes) { attributes_for(:order).except(:order_details) }

  let(:order) { Order.create valid_attributes }

  before { sign_in admin }

  describe 'GET #index' do
    it 'returns a success response' do
      order
      get :index, params: {}
      expect(response.status).to eq 200
      expect(response).to be_success
    end

    it 'return a result of customer first name filter' do
      order
      get :index, params: { by_customer_name: 'first' }, format: :json
      expect(response.status).to eq 200
      expect(response.body).not_to eql '[]'
    end

    it 'return a result of customer last name filter' do
      order
      get :index, params: { by_customer_name: 'last' }, format: :json
      expect(response.status).to eq 200
      expect(response.body).not_to eql '[]'
    end

    it 'return a result of phone filter' do
      order
      get :index, params: { by_phone: phone }
      expect(response.status).to eq 200
      expect(response.body).not_to eql '[]'
    end

    it 'return a result of phone normalize filter' do
      order
      get :index, params: { by_phone: normalized_phone }
      expect(response.status).to eq 200
      expect(response.body).not_to eql '[]'
    end

    it 'return phone filter not found' do
      order
      get :index, params: { by_phone: '090000022' }, format: :json
      expect(response.body).to eq '[]'
    end

    it 'return a result of paid filter' do
      order
      get :index, params: { by_paid: true }, format: :json
      expect(response.status).to eq 200
      expect(response.body).not_to eql '[]'
    end

    it 'return purchased date filter not found' do
      order
      get :index, params: { by_purchased_date: [Date.today - 1.day, Date.today - 1.day] }, format: :json
      expect(response.status).to eq 200
      expect(response.body).to eq '[]'
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: order.to_param }
      expect(response).to be_success
    end
  end

  describe 'GET #logs' do
    it 'returns a success response' do
      order = Order.create! valid_attributes
      get :logs, params: { id: order.to_param }
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
      get :edit, params: { id: order.to_param }
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:action) do
        post :create, params: { order: valid_attributes }
      end

      it 'creates a new Order' do
        action
        expect(Order.count).to eq(1)
        expect(OrderDetail.count).to eq(1)
      end

      it 'redirects to the created order' do
        post :create, params: { order: valid_attributes }
        expect(response).to redirect_to(orders_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { order: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        order_attrs = valid_attributes.merge(paid: true)
        order_detail_attrs = order_detail.merge(id: OrderDetail.last.id, quantity: 1)
        order_attrs[:order_details_attributes] = [order_detail_attrs]

        order_attrs
      end

      it 'updates the requested order' do
        put :update, params: { id: order.to_param, order: new_attributes }
        order.reload

        expect(order.paid).to eq(true)
        expect(order.order_details.first.quantity).to eq(1)
      end

      it 'redirects to the order' do
        put :update, params: { id: order.to_param, order: valid_attributes }
        expect(response).to redirect_to(orders_path)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: {
          id: order.to_param,
          order: invalid_attributes.merge(order_details_attributes: { '0' => invalid_order_detail })
        }
        expect(response).to be_success
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested order' do
      order
      expect do
        delete :destroy, params: { id: order.to_param }
      end.to change(Order, :count).by(-1)
    end

    it 'redirects to the orders list' do
      delete :destroy, params: { id: order.to_param }
      expect(response).to redirect_to(orders_url)
    end
  end

  describe 'POST #create and update points' do
    let!(:loyal) { create(:loyalty_point_rule, code: 'COM', active: true) }
    let!(:conversion) { create(:conversion_rate, code: 'M2P', money: 10_000, point: 1, active: true) }

    context 'with valid params' do
      let(:action) { post :create, params: { order: valid_attributes } }

      it 'return 200 and update point for customer' do
        expect(customer.point).to eq(0)
        action
        customer.reload
        expect(customer.point).to eq(30)
      end
    end

    context 'with unpaid or uncompleted order' do
      let(:action) { post :create, params: { order: valid_attributes.except(:status, :paid) } }

      it 'return 200 and not update point' do
        expect(customer.point).to eq(0)
        action
        customer.reload
        expect(customer.point).to eq(0)
      end
    end
  end

  describe 'PUT #update order' do
    let!(:loyal) { create(:loyalty_point_rule, code: 'COM', active: true) }
    let!(:conversion) { create(:conversion_rate, code: 'M2P', money: 10_000, point: 1, active: true) }
    let!(:unpaid_order) { Order.create valid_attributes.except(:status, :paid) }

    it 'return 200 and update point if valid order' do
      expect(customer.point).to eq(0)
      put :update, params: { id: unpaid_order.id, order: { paid: true } }
      customer.reload
      expect(customer.point).to eq(30)
    end

    context 'not update twice' do
      let!(:history_point) { create(:history_point, customer: customer, order: unpaid_order) }

      it 'return 200 and update point if valid order' do
        expect(customer.point).to eq(0)
        put :update, params: { id: unpaid_order.id, order: { paid: true } }
        customer.reload
        expect(customer.point).to eq(0)
      end
    end
  end

  describe 'PUT #update order first ticket earn points' do
    let!(:customer2) { create(:customer, referral_code: 'hello') }
    let!(:ftk) { create(:loyalty_point_rule, code: 'FTK', active: true, point: 10) }
    let!(:unpaid_order) { Order.create valid_attributes.except(:status, :paid) }
    let(:second_order) { Order.create valid_attributes.except(:status, :paid) }

    it 'return 200 and update points for both' do
      expect(customer.point).to eq(0)
      put :update, params: { id: unpaid_order.id, order: { paid: true } }
      customer.reload && customer2.reload
      expect([customer.point, customer2.point]).to eq([10, 10])
      expect(HistoryPoint.count).to eq(2)
    end

    # rubocop:disable ExampleLength
    it 'not update if order greater than 1' do
      expect(customer.point).to eq(0)
      put :update, params: { id: unpaid_order.id, order: { paid: true } }
      customer.reload && customer2.reload
      expect([customer.point, customer2.point]).to eq([10, 10])
      expect(HistoryPoint.count).to eq(2)
      put :update, params: { id: second_order.id, order: { paid: true } }
      customer.reload && customer2.reload
      expect([customer.point, customer2.point]).to eq([10, 10])
      expect(HistoryPoint.count).to eq(2)
    end
  end
end
