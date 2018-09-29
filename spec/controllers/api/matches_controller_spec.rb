require 'rails_helper'

describe Api::MatchesController do
  include_context 'initialize auth'

  describe 'GET #index' do
    let(:expected_error) { { error: { message: 'invalid_params' } } }
    let!(:match) { create(:match, start_time: 2.days.from_now) }
    let!(:match1) { create(:match, start_time: 3.days.from_now) }
    let(:action) { get :index, params: params }

    before { action }

    context 'valid params' do
      let(:params) do
        {
          pagination: {
            page: 1,
            per_page: 10
          },
          field: {
            type: 1,
            venues: [match.stadium_id, 2, 3]
          }
        }
      end

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      it 'returns correct data' do
        response_data = JSON.parse(response.body)
        expect(response_data['data'][0]['id']).to eq(match.id)
        expect(response_data['data'][0]['type']).to eq(match.schedule)
        expect(response_data['data'][0]['home']['name']).to eq(match.home_team.name)
        expect(response_data['total']).to eq(1)
      end
    end

    context 'order matches' do
      let(:params) do
        {
          pagination: {
            page: 1,
            per_page: 10
          },
          field: {
            type: 1
          }
        }
      end

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      it 'return matches asc' do
        response_data = JSON.parse(response.body)
        expect(response_data['data'][1]['id']).to eq(match1.id)
        expect(response_data['data'][1]['type']).to eq(match1.schedule)
        expect(response_data['data'][1]['home']['name']).to eq(match1.home_team.name)
        expect(response_data['total']).to eq(2)
      end
    end

    context 'invalid params' do
      let(:params) { { code: 'params' } }

      it 'returns 400 Bad Request status' do
        expect(response.status).to eq(400)
      end

      it 'returns false active' do
        expect(response.body).to eq(expected_error.to_json)
      end
    end

    context 'order past matches' do
      let(:params) do
        {
          pagination: {
            page: 1,
            per_page: 10
          },
          field: {
            type: 2
          }
        }
      end
      let!(:match) { create(:match, start_time: 2.days.ago) }
      let!(:match1) { create(:match, start_time: 3.days.ago) }

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      it 'return matches asc' do
        response_data = JSON.parse(response.body)
        expect(response_data['data'][0]['id']).to eq(match.id)
        expect(response_data['data'][0]['type']).to eq(match.schedule)
        expect(response_data['data'][0]['home']['name']).to eq(match.home_team.name)
        expect(response_data['total']).to eq(2)
      end
    end
  end
end
