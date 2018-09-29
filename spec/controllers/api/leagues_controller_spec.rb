require 'rails_helper'

RSpec.describe Api::LeaguesController, type: :controller do
  describe 'get #index api league' do
    include_context 'initialize auth'
    let!(:leagues) { create_list(:league, 5, active: true) }

    it 'return 1 active league and status 200' do
      get :index
      expect(response.status).to eq(200)
      data_json = JSON.parse(response.body)
      expect(data_json.size).to eq(1)
    end

    context 'get api with invalid params' do
      it 'return 1 active league and status 200 too' do
        get :index, params: { invalid: 'invalid' }
        expect(response.status).to eq(200)
        data_json = JSON.parse(response.body)
        expect(data_json.size).to eq(1)
      end
    end
  end
end
