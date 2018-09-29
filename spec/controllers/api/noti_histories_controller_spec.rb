require 'rails_helper'

RSpec.describe Api::NotiHistoriesController, type: :controller do
  describe 'get #index without signed in' do
    it 'return 403 status' do
      get :index
      expect(response.status).to eq(403)
    end
  end

  describe 'get #index with signed in customer' do
    include_context 'initialize auth'
    let!(:histories) do
      create_list(:noti_history, 3, customer: customer,
                                    title: 'MyString', body: 'MyBody', status: true, seen: true)
    end
    let!(:false_histories) do
      create_list(:noti_history, 3, customer: customer,
                                    title: 'FalseString', body: 'FalseBody', status: false, seen: false)
    end

    it 'return 200 and 3 histories' do
      get :index
      expect(response.status).to eq(200)
      data = JSON.parse(response.body)
      expect(data['data'].size).to eq(3)
    end

    it 'update all seen to true and return 200' do
      noti = customer.noti_histories.where(seen: true)
      expect(noti.count).to eq(3)
      post :check_seen
      noti.reload
      expect([noti.count, response.status]).to eq([6, 200])
    end
  end
end
