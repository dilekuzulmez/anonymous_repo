require 'rails_helper'

RSpec.describe Api::StadiumsController, type: :controller do
  include_context 'initialize auth'
  describe 'get #index stadiums' do
    let!(:stadiums) { create_list(:stadium, 5) }

    context 'without params passed' do
      let!(:action) { get :index }

      it 'return 5 stadiums' do
        data = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(data['stadiums'].size).to eq(5)
      end
    end

    context 'invalid params passed' do
      let!(:action) { get :index, params: { invalid: 'invalid' } }

      it 'return 200 and 5 stadiums' do
        data = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(data['stadiums'].size).to eq(5)
      end
    end

    context 'do not have any stadium update' do
      let!(:action) { get :index, params: { timestamp: (stadiums.first.updated_at + 2.hours).to_i } }

      it 'return 200 and 0 stadiums' do
        data = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(data['stadiums'].size).to eq(0)
      end
    end

    context 'if have any stadium updated' do
      let!(:action) { get :index, params: { timestamp: (stadiums.first.updated_at - 2.hours).to_i } }

      it 'return 200 and 5 stadiums' do
        data = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(data['stadiums'].size).to eq(5)
      end
    end
  end
end
