require 'rails_helper'

describe Api::BaseController, type: :controller do
  controller(Api::BaseController) do
    def index
      head 200
    end
  end

  describe 'authenticate_customer!' do
    context 'missing header' do
      it 'returns 403 error' do
        get :index
        expect(response.status).to eq(403)
      end
    end

    context 'valid header' do
      let(:customer) { create(:customer) }

      it 'returns 200' do
        request.headers['Token'] = customer.access_token
        get :index

        expect(response.status).to eq(200)
      end
    end
  end
end
