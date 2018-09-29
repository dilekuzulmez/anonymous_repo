require 'rails_helper'

describe Api::ConversionRatesController, type: :controller do
  include_context 'initialize auth'
  describe 'get #p2m' do
    let!(:p2m) { create(:conversion_rate, code: 'P2M', active: true) }

    it 'return 200 and show data' do
      get :p2m
      data = JSON.parse(response.body)
      expect(data['data']['code']).to eq('P2M')
      expect(response.status).to eq(200)
    end
  end
end
