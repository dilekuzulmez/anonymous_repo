require 'rails_helper'

describe Api::TeamsController, type: :controller do
  describe 'GET #index' do
    include_context 'initialize auth'
    let!(:abl_season) { create(:season) }

    it 'return 7 teams' do
      get :index
      data_response = JSON.parse(response.body)
      expect(data_response['teams'].size).to eq(7)
    end
  end
end
