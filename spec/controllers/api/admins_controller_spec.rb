require 'rails_helper'

describe Api::AdminsController do
  include_context 'employee initialize auth'

  describe 'GET #list' do
    let!(:season) { create(:season) }
    let!(:match) { create(:match, start_time: Time.now.end_of_day, season_id: season.id) }

    let(:action) do
      get :list, params: {}
    end

    it 'return today upcomming match' do
      action
      expect(JSON.parse(response.body).first).to eq JSON.parse(match.to_json)
    end

    it 'return playing match' do
      match.update_columns(start_time: Time.current - 1.hours)
      action
      expect(JSON.parse(response.body).first).to eq JSON.parse(match.to_json)
    end
  end
end
