require 'rails_helper'

describe Api::BaseEmployeeController, type: :controller do
  controller(Api::BaseEmployeeController) do
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
      let(:admin) { create(:admin, employee_token: Devise.friendly_token, token_expire: Time.now + 2.days) }

      it 'returns 200' do
        request.headers['token'] = admin.employee_token
        get :index

        expect(response.status).to eq(200)
      end
    end
  end
end
