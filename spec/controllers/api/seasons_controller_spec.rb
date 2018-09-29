require 'rails_helper'

describe Api::SeasonsController do
  include_context 'initialize auth'
  describe 'GET #season_ticket' do
    let!(:team_a) { create(:team) }
    let!(:team_b) { create(:team) }
    let!(:team_c) { create(:team) }
    let!(:league) { create(:league) }

    it 'returns 200 status' do
      expect(response.status).to eq(200)
    end
    context 'vba league' do
      let!(:vba_season) do
        create(:season,
               name: 'vba',
               league_id: league.id,
               teams: [team_a, team_b, team_c],
               season_ticket_team_ids: [team_a.id, team_c.id],
               is_active: true)
      end

      it 'without type and return VBA season' do
        get :season_ticket, params: { league_id: league.id }
        response_data = JSON.parse(response.body)
        expect(response_data['teams'].count).to eq 2
        expect(response_data['teams'][0]['id']).to eq team_a.id
        expect(response_data['teams'][1]['id']).to eq team_c.id
      end
    end

    context 'abl league' do
      let!(:abl_season) do
        create(:season,
               name: 'abl',
               league_id: league.id,
               teams: [team_a, team_b, team_c],
               season_ticket_team_ids: [team_a.id, team_b.id, team_c.id],
               is_active: true)
      end

      it 'with type is ABL' do
        get :season_ticket, params: { league_id: league.id }
        expect(response.status).to eq 200
        data = JSON.parse(response.body)
        expect(data['teams'].count).to eq 3
        expect(data['teams'][2]['id']).to eq(team_c.id)
      end
    end

    it 'invalid type' do
      get :season_ticket, params: { league_id: league.id + 1 }
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['teams']).to eq(nil)
    end
  end
end
