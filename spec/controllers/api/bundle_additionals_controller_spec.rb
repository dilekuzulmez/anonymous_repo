require 'rails_helper'

describe Api::BundleAdditionalsController, type: :controller do
  describe 'GET #index' do
    include_context 'initialize auth'
    let!(:team) { create(:team) }
    let!(:bundle_additional_1) { create(:bundle_additional, is_active: true, code: 'abc') }
    let!(:bundle_additional_2) { create(:bundle_additional, is_active: true, code: 'def') }
    let!(:bundle_additional_3) { create(:bundle_additional, is_active: false, code: 'ghi') }

    context 'list bundle additionals' do
      it 'return 2 bundle_additional' do
        get :index, params: {}
        data_response = JSON.parse response.body
        expect(response.code).to eq('200')
        expect(data_response['data'].count).to eq 2
      end
    end
  end
end
