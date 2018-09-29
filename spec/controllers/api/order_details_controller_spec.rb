require 'rails_helper'

describe Api::OrderDetailsController do
  include OrderQrUtils
  include_context 'employee initialize auth'
  let!(:customer) { create(:customer) }
  let!(:match) { create(:match) }
  let!(:ticket_type) { create(:ticket_type, match: match, quantity: 1000, price: '300') }
  let(:order_params) do
    attributes_for(:order,
                   paid: true,
                   order_details: [build(:order_detail, ticket_type: ticket_type, quantity: 2, match: match)],
                   customer_id: customer.id)
  end
  let!(:order) { Order.create(order_params) }

  let(:order_detail_params) do
    attributes_for(:order_detail,
                   ticket_type_id: ticket_type.id,
                   unit_price: ticket_type.price,
                   order: order,
                   quantity: 1,
                   match_id: match.id)
  end

  let!(:detail) do
    detail = OrderDetail.create(order_detail_params)
    GenerateQrCodeJob.perform_now(detail.id)
    detail
  end

  let(:hash_key) { detail.qr_codes.ticket.first.hash_key }
  let(:request_params) { { id: detail.id, number: 0, hash_key: hash_key, match_id: ticket_type.match_id } }
  let(:action) { post :scan_and_checkin, params: request_params }

  let(:purchase) { post :purchase, params: { id: detail.id, paid_value: order.total_after_discount * 2 } }
  let(:purchase_error) { post :purchase, params: { id: detail.id, paid_value: order.total_after_discount - 1 } }

  describe 'POST #checkin' do
    it 'return vali ticket result' do
      action
      expect(response.code).to eq('200')
      expect(response.body).to include(order.id.to_s)
    end

    it 'checkin with invalid code format' do
      request_params[:hash_key] = 'sdsdadasdsadascdcsdcsdeewrwerwer'
      action
      expect(response.code).to eq('400')
    end

    it 'checkin to wrong match' do
      request_params[:match_id] = -1
      action
      expect(response.code).to eq('400')
    end

    # rubocop:disable ExampleLength
    it 'checkin with unpaid order' do
      order.update_columns(paid: false)
      request_params[:hash_key] = order.order_details.first.qr_codes.payment.first.hash_key
      request_params[:id] = order.order_details.first.id
      action
      expect(response.code).to eq('200')
      expect(JSON.parse(response.body)['order_id']).to eq(order.id)
    end
  end

  describe 'POST #purchase' do
    it 'result purchased success' do
      purchase
      expect(response.body).to eq('purchased')
      expect(response.code).to eq('200')
    end

    it 'result purchased error' do
      purchase_error
      expect(response.body).not_to eq('purchased')
      expect(response.code).to eq('400')
    end

    context 'update points is purchase ok' do
      let!(:loyal) { create(:loyalty_point_rule, code: 'COM', active: true) }
      let!(:conversion) { create(:conversion_rate, code: 'M2P', money: 100, point: 1, active: true) }

      it 'return 200 and update points for customer' do
        expect(customer.point).to eq(0)
        purchase
        customer.reload
        expect(customer.point).to eq(9)
        expect(response.status).to eq(200)
      end
    end

    context 'already updated points' do
      let!(:loyal) { create(:loyalty_point_rule, code: 'COM', active: true) }
      let!(:conversion) { create(:conversion_rate, code: 'M2P', money: 100, point: 1, active: true) }
      let!(:history_point) { create(:history_point, customer: customer, order: order) }

      it 'return 200 and make sure not update anymore' do
        expect(customer.point).to eq(0)
        purchase
        customer.reload
        expect(customer.point).to eq(0)
        expect(response.status).to eq(200)
      end
    end

    context 'disable conversion rate' do
      let!(:loyal) { create(:loyalty_point_rule, code: 'COM', active: true) }
      let!(:conversion) { create(:conversion_rate, code: 'M2P', money: 100, point: 1, active: false) }

      it 'return 200 and make sure not update' do
        expect(customer.point).to eq(0)
        purchase
        customer.reload
        expect(customer.point).to eq(0)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'POST check in with unspecific QR code' do
    let!(:unspecify_qr) do
      QrCode.create(hash_key: 'aaa', home_team: match.home_team,
                    ticket_type: match.ticket_types.first.code, channel: 'MB')
    end
    let(:qr_params) { { id: 0, hash_key: unspecify_qr.hash_key, match_id: match.id } }
    let(:scan_qr) { post :scan_and_checkin, params: qr_params }
    let!(:mb) { create(:customer, email: 'mb@bank.com') }
    let!(:match2) { create(:match) }

    it 'can scan a specify QR & create order' do
      scan_qr
      expect(response.status).to eq(200)
      expect(Order.last.sale_channel).to eq('MB')
      expect(Order.last.qr_codes.first.hash_key).to eq('aaa')
    end

    it 'return invalid match' do
      post :scan_and_checkin, params: { id: 0, hash_key: unspecify_qr.hash_key, match_id: match2.id }
      expect(response.status).to eq(400)
      expect(response.body).to include('invalid match')
    end
  end
end
