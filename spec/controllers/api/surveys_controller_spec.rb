require 'rails_helper'

RSpec.describe Api::SurveysController, type: :controller do
  describe 'without signed in customer' do
    it 'get #index api survey' do
      get :index
      expect(response.status).to eq(403)
    end
  end

  describe 'signed in customer' do
    let!(:surveys) { create_list(:survey, 3) }
    let!(:survey) { create(:survey, active: false) }

    include_context 'initialize auth'

    it 'return 200 and 3 surveys' do
      get :index
      data = JSON.parse(response.body)
      expect(data['data'].size).to eq(3)
    end
  end
end
