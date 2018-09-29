require 'rails_helper'
describe Api::CustomersController do
  describe 'without signed in get #history_points' do
    it 'return 403 status' do
      get :history_points
      expect(response.status).to eq(403)
    end
  end

  describe 'get #history_points' do
    include_context 'initialize auth'
    let(:survey) { create(:survey, active: true) }
    let(:udp) { create(:loyalty_point_rule, active: true) }
    let!(:history_point1) { create(:history_point, customer: customer, survey: survey, point: 100) }
    let!(:history_point2) { create(:history_point, customer: customer, loyalty_point_rule: udp, point: 100) }

    it 'return 2 histories and status 200' do
      get :history_points
      data = JSON.parse(response.body)
      expect(data['data'].size).to eq(2)
    end
  end

  describe 'POST #auth' do
    let(:action) { post :auth, params: params }

    context 'valid auth code' do
      let(:customer) { create(:customer) }
      let(:params) { { code: 'abc', provider: 'account_kit' } }
      let(:mock_new_customer) { false }

      before do
        allow_any_instance_of(LoginCustomerService).to receive(:execute).and_return(true)
        allow_any_instance_of(LoginCustomerService).to receive(:customer).and_return(customer)
        allow_any_instance_of(LoginCustomerService).to receive(:new_customer?).and_return(mock_new_customer)

        action
      end

      it_behaves_like 'a successful request'

      context 'new customer' do
        let(:mock_new_customer) { true }

        it 'returns http 201' do
          expect(response.status).to eq(201)
        end
      end

      it 'returns json of customer' do
        expect(response.body).to eq({ access_token: customer.access_token,
                                      phone_number: customer.phone_number,
                                      email: customer.email }.to_json)
      end
    end

    context 'invalid params' do
      before { action }
      let(:expected_error) { { error: { message: error_message } } }
      let(:params) { {} }

      it_behaves_like 'an unsuccessful request'

      context 'missing code params' do
        let(:params) { { provider: 'account_kit' } }
        let(:error_message) { 'Missing Token' }

        it 'returns error message' do
          expect(response.body).to eq(expected_error.to_json)
        end
      end

      context 'invalid provider' do
        let(:params) { { code: 'abc' } }
        let(:error_message) { 'Unknown Provider' }

        it 'returns error message' do
          expect(response.body).to eq(expected_error.to_json)
        end
      end

      context 'invalid code' do
        let(:params) { { code: 'abc', provider: 'account_kit' } }
        let(:error_message) { 'Invalid verification code' }

        it 'returns error message' do
          expect(response.body).to eq(expected_error.to_json)
        end

        it_behaves_like 'an unsuccessful request'
      end
    end
  end

  describe 'GET #me' do
    include_context 'initialize auth'

    let(:action) { get :me }
    let(:expected_data) { customer.attributes.except('access_token', 'external_uid', 'provider').to_json }

    before { action }

    it_behaves_like 'a successful request'

    it 'returns expected data' do
      new_response = JSON.parse(response.body).except('is_logined_facebook').to_json
      expect(JSON.parse(new_response)).to eq(JSON.parse(expected_data))
    end
  end

  describe 'PUT #update' do
    include_context 'initialize auth'
    let(:action) { put :update, params: params }

    before { action }

    context 'valid params' do
      let(:params) { { email: 'hello@world.com' } }

      it_behaves_like 'a successful request'
    end

    context 'invalid params' do
      let(:params) { { email: 'hello' } }

      it_behaves_like 'an unsuccessful request'

      it 'returns error messages' do
        expect(response.body).to eq({ error: { message: ['Email is invalid'] } }.to_json)
      end
    end

    context 'not whitelist params' do
      let(:params) { { black_list: 'hello' } }

      it_behaves_like 'an unsuccessful request'
    end
  end

  describe 'PUT #profile_image' do
    include_context 'initialize auth'

    let(:file_path) { File.open("#{Rails.root}/spec/fixtures/sample_profile_image.jpg") }
    let(:uploaded_file) { Rack::Test::UploadedFile.new(file_path) }
    let(:action) { put :upload_profile_image, params: { profile_image: params } }
    let(:url) { 'https:google.com' }
    let(:expected_data) { { profile_image_url: url } }

    before do
      allow_any_instance_of(UploadProfileImageService).to receive(:execute).and_return(url)

      action
    end

    context 'valid params' do
      let(:params) { uploaded_file }

      it_behaves_like 'a successful request'

      it 'returns expected data' do
        expect(response.body).to eq(expected_data.to_json)
      end
    end

    context 'invalid params' do
      let(:params) { nil }

      it_behaves_like 'a successful request'

      it 'returns expected data' do
        expect(response.body).to eq(expected_data.to_json)
      end
    end
  end

  describe 'PUT #update profile & add points' do
    include_context 'initialize auth'
    let!(:udp) { create(:loyalty_point_rule, active: true) }
    let(:action) { put :update, params: { address: { district: '11', city: 'HCM', street: 'HTQ' } } }

    context 'it is the first time customer earn points' do
      it 'add points after profile updated' do
        expect(customer.point).to eq(0)
        action
        customer.reload
        expect(customer.point).to eq(10)
        expect(customer.noti_histories.count).to eq(1)
      end
    end

    context 'it is the second time customer update profile' do
      let!(:history_point) { create(:history_point, customer: customer, loyalty_point_rule: udp) }

      it 'not add points anymore' do
        expect(customer.point).to eq(0)
        action
        customer.reload
        expect(customer.point).to eq(0)
      end
    end
  end

  describe 'GET #detect_user' do
    let(:action) { get :detect_user, params: { info: 'hello@gmail.com' } }

    context 'it still not logged in' do
      it 'return 403 status' do
        action
        expect(response.status).to eq(403)
      end
    end

    context 'loggin user request' do
      let!(:customer2) { create(:customer, email: 'hello@gmail.com') }

      include_context 'initialize auth'
      it 'return status 400 unless params' do
        get :detect_user
        expect(response.status).to eq(400)
      end

      it 'return customer info if params valid' do
        action
        expect(response.status).to eq(200)
        data = JSON.parse(response.body)
        expect(data['data'].size).to eq(1)
      end
    end
  end

  describe 'Get Orders' do
    # rubocop:disable ExampleLength

    include_context 'initialize auth'
    let!(:match) { create(:match) }
    let!(:ticket_type) { create(:ticket_type, match: match, quantity: 1000, price: '300') }

    ### Create mock data : paid order, order detail, paid qr code

    let(:paid_order_detail) { build(:order_detail, ticket_type: ticket_type, quantity: 3, match: match) }
    let(:paid_order_params) do
      attributes_for(:order,
                     paid: true,
                     order_details: [paid_order_detail],
                     customer_id: customer.id,
                     expired_at: Time.zone.now + 1.month)
    end
    let!(:paid_order) { Order.create(paid_order_params) }

    let!(:paid_detail) do
      GenerateQrCodeJob.perform_now(paid_order_detail.id)
    end

    ### Create mock data : unpaid order, order detail, paid qr code

    let(:unpaid_order_detail) { build(:order_detail, ticket_type: ticket_type, quantity: 1, match: match) }
    let(:unpaid_order_params) do
      attributes_for(:order,
                     paid: false,
                     order_details: [unpaid_order_detail],
                     customer_id: customer.id,
                     expired_at: Time.zone.now + 1.month)
    end
    let!(:unpaid_order) { Order.create(unpaid_order_params) }

    let!(:unpaid_detail) do
      GenerateQrCodeJob.perform_now(unpaid_order_detail.id)
    end

    let!(:udp) { create(:loyalty_point_rule, active: true) }
    let(:action) { get :orders, params: { field: { status: 'paid' }, pagination: { page: 1, per_page: 2 } } }

    context 'return paid orders that doesnt include ticket' do
      it 'return order' do
        paid_detail
        unpaid_detail
        action
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data'].count).to eq(1)
        expect(JSON.parse(response.body)['data'].first['tickets']).to eq(paid_order_detail[:quantity])
      end
    end

    context 'return unpaid orders that doesnt include ticket' do
      # rubocop:disable LineLength

      let(:action) { get :orders, params: { field: { status: 'unpaid' }, pagination: { page: 1, per_page: 2 } } }

      it 'return order' do
        paid_detail
        unpaid_detail
        action
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data'].count).to eq(1)
        expect(JSON.parse(response.body)['data'].first['tickets']).to eq(unpaid_order_detail[:quantity])
      end
    end
  end

  describe 'Get tickets' do
    include_context 'initialize auth'
    let!(:match) { create(:match) }
    let!(:ticket_type) { create(:ticket_type, match: match, quantity: 1000, price: '300') }

    ### Create customer
    let(:customer_to_transfer) { create(:customer) }

    ### Create mock data : paid order, order detail, paid qr code

    let(:paid_order_detail) { build(:order_detail, ticket_type: ticket_type, quantity: 3, match: match) }
    let(:paid_order_params) do
      attributes_for(:order,
                     paid: true,
                     order_details: [paid_order_detail],
                     customer_id: customer.id)
    end
    let!(:paid_order) { Order.create(paid_order_params) }

    let!(:paid_detail) do
      GenerateQrCodeJob.perform_now(paid_order_detail.id)
    end

    ### Create mock data : unpaid order, order detail, paid qr code

    let(:unpaid_order_detail) { build(:order_detail, ticket_type: ticket_type, quantity: 1, match: match) }
    let(:unpaid_order_params) do
      attributes_for(:order,
                     paid: false,
                     order_details: [unpaid_order_detail],
                     customer_id: customer.id,
                     expired_at: match.start_time - 1.day)
    end
    let!(:unpaid_order) { Order.create(unpaid_order_params) }

    let!(:unpaid_detail) do
      GenerateQrCodeJob.perform_now(unpaid_order_detail.id)
    end

    let!(:udp) { create(:loyalty_point_rule, active: true) }
    let(:action) { get :tickets, params: { field: { status: 'valid' }, pagination: { page: 1, per_page: 10 } } }
    let(:action_transfer_ticket) { post :transfer_ticket, params: { id: customer_to_transfer.id, ticket_id: paid_order.qr_codes.ticket.first.id } }

    context 'return paid orders that doesnt include ticket' do
      it 'return order' do
        paid_detail
        unpaid_detail
        action
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data'].count).to eq(1)
      end
    end

    context 'transfer ticket success' do
      it 'return order' do
        paid_detail
        unpaid_detail
        action_transfer_ticket
        expect(response.status).to eq(200)
        expect(customer.qr_codes.count).to eq(3)
        expect(customer_to_transfer.qr_codes.count).to eq(1)
      end
    end
  end
end
