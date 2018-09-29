require 'rails_helper'

describe Api::OrdersController do
  include_context 'initialize auth'
  let!(:season_discount) { create(:loyalty_point_rule, code: 'SEASON_DISCOUNT') }
  let(:admin) { create(:admin) }
  let!(:customer) { create(:customer, point: 1000) }
  let!(:match) { create(:match, start_time: 2.days.from_now) }
  let!(:promotion) { create(:promotion, :active, code: 'abc', discount_type: 'amount', discount_amount: 10) }
  let(:ticket_type) { create(:ticket_type, match: match, price: 300_000) }
  let!(:matchs_promotion) { create(:matchs_promotion, match: match, promotion: promotion) }
  let!(:bundle_additional_1) do
    create(:bundle_additional, ticket_type: ticket_type, price: 300_000, league_id: match.season.league.id)
  end
  let!(:bundle_additional_2) { create(:bundle_additional) }

  let(:order_detail) do
    {
      ticket_type_id: ticket_type.id,
      unit_price: ticket_type.price,
      quantity: 3,
      match_id: match.id
    }
  end

  let(:invalid_order_detail) do
    {
      ticket_type_id: ticket_type.id,
      unit_price: ticket_type.price,
      quantity: 3,
      match_id: nil
    }
  end

  let(:order_params) do
    {
      order: {
        shipping_address: 'vietnam',
        promotion_code: 'abc',
        order_details_attributes: [order_detail]
      }
    }
  end

  let(:order_point_paid_params) do
    {
      order: {
        shipping_address: 'vietnam',
        order_details_attributes: [order_detail]
      }
    }
  end

  let(:check_order_params) do
    {
      order: {
        seat_ids: %w[seat selection],
        shipping_address: 'vietnam',
        order_details_attributes: [order_detail]
      }
    }
  end

  let(:season_order_with_bundle_params) do
    {
      order: {
        home_team_id: match.home_team_id,
        league_id: match.season.league.id,
        shipping_address: 'vietnam',
        bundle_additional_id: bundle_additional_1.id,
        order_details_attributes: [order_detail]
      }
    }
  end

  let(:season_order_with_bundle_invalid_params) do
    {
      order: {
        home_team_id: match.home_team_id,
        shipping_address: 'vietnam',
        bundle_additional_id: bundle_additional_2.id,
        order_details_attributes: [order_detail]
      }
    }
  end

  let(:invalid_attributes) do
    {
      order: {
        shipping_address: 'vietnam',
        promotion_code: 'abc',
        order_details_attributes: [invalid_order_detail]
      }
    }
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:action) do
        post :create, params: order_params
      end

      it 'creates a new Order' do
        action
        expect(response.code).to eq('200')
        expect(Order.count).to eq(1)
        expect(Order.first.sale_channel).to eq('COD')
        expect(OrderDetail.count).to eq(1)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: invalid_attributes
        expect(response).not_to be_success
      end
    end

    context 'with bundle additional valid' do
      it 'valid bundle additional' do
        post :create, params: season_order_with_bundle_params
        expect(response.code).to eq('200')
      end
    end

    context 'with bundle additional invalid' do
      it 'valid bundle additional' do
        post :create, params: season_order_with_bundle_invalid_params
        expect(response.code).to eq('400')
      end
    end
  end

  describe 'POST #point_paid' do
    let!(:p2m) { create(:conversion_rate, code: 'P2M', money: 1000, point: 1, active: true) }
    let!(:m2p) { create(:conversion_rate, code: 'M2P', money: 10_000, point: 1, active: true) }
    let!(:com) { create(:loyalty_point_rule, code: 'COM', active: true) }
    let(:create_order) do
      post :create, params: order_point_paid_params
    end
    let(:paid_by_point) do
      post :point_paid, params: { order_id: customer.orders.last.id }
    end

    it 'accept to be purchased if enough point' do
      create_order
      paid_by_point
      expect(response.status).to eq(200)
      customer.reload
      expect(customer.point).to eq(190)
    end
  end

  describe 'POST #point_paid_scanner' do
    let!(:p2m) { create(:conversion_rate, code: 'P2M', money: 1000, point: 1, active: true) }
    let!(:m2p) { create(:conversion_rate, code: 'M2P', money: 10_000, point: 1, active: true) }
    let!(:com) { create(:loyalty_point_rule, code: 'COM', active: true) }
    let(:create_order) do
      post :create, params: order_point_paid_params
    end
    let(:paid_by_point) do
      post :point_paid_scanner, params: { customer_id: customer.id, order_id: customer.orders.last.id }
    end

    it 'accept to be purchased if enough point' do
      create_order
      paid_by_point
      expect(response.status).to eq(200)
      customer.reload
      expect(customer.point).to eq(190)
    end
  end

  describe 'GET #check_order' do
    let(:create_order) do
      Order.new(seat_ids: %w[seat selection]).save(validate: false)
    end

    it 'return 422 if seat_ids not containing in DB' do
      create_order
      get :check_order, params: { seat_id: 'nonsense' }
      expect(response.status).to eq(422)
    end

    it 'return 400 if seat_ids is blank' do
      create_order
      get :check_order
      expect(response.status).to eq(400)
    end

    it 'return 200 if seat_ids is containing in DB' do
      create_order
      get :check_order, params: { seat_id: 'seat' }
      expect(response.status).to eq(200)
    end
  end
end
