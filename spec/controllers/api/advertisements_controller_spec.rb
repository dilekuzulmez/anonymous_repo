require 'rails_helper'

RSpec.describe Api::AdvertisementsController, type: :controller do
  describe 'get #index ads' do
    let!(:season_discount) { create(:loyalty_point_rule, code: 'SEASON_DISCOUNT') }
    let!(:promotion) { create(:promotion) }
    let!(:ads) { create_list(:advertisement, 3, promotion_id: promotion.id) }
    let!(:ad) { create(:advertisement, active: false) }
    let!(:ad2) { create(:advertisement, title: 'Priority', active: true, priority: true) }

    context 'with no auth' do
      it 'return 403 status' do
        get :index
        expect(response.status).to eq(403)
      end
    end

    context 'with valid auth' do
      include_context 'initialize auth'
      it 'return 4 active ads' do
        get :index
        data = JSON.parse(response.body)
        expect(data['ads'].size).to eq(4)
        expect(data['ads'].first['title']).to eq('Priority')
      end
    end
  end

  describe 'get #show ad' do
    let!(:promotion) { create(:promotion) }
    let!(:match) { create(:match) }
    let!(:match_promotion) { create(:matchs_promotion, match_id: match.id, promotion_id: promotion.id) }
    let!(:ad) { create(:advertisement, promotion_id: promotion.id) }

    context 'with no auth' do
      it 'return 403 status' do
        get :show, params: { id: ad.id }
        expect(response.status).to eq(403)
      end
    end

    context 'with valid auth' do
      include_context 'initialize auth'
      it 'return 200 and matches' do
        get :show, params: { id: ad.id }
        data = JSON.parse(response.body)
        expect(data['data'].size).to eq(1)
      end

      it 'return 404 and record not found if invalid id' do
        get :show, params: { id: ad.id + 1000 }
        expect(response.status).to eq(404)
        expect(response.body).to include('Record Not Found')
      end
    end
  end
end
