require 'rails_helper'

describe Api::PromotionsController do
  describe 'GET #check' do
    include_context 'initialize auth'
    let(:expected_error) { { error: { message: 'Not exist' } } }
    let!(:promotion) { create(:promotion, :active, code: 'abc') }
    let(:action) { get :check, params: params }
    let!(:match) { create(:match) }
    let!(:matchs_promotion) { create(:matchs_promotion, match: match, promotion: promotion) }

    before { action }

    context 'valid params' do
      let(:params) { { code: 'abc', match_id: match.id } }
      let(:data) do
        {
          id: promotion.id,
          code: promotion.code,
          matches: [
            match_id: match.id
          ],
          discount_type: promotion.discount_type,
          discount_amount: promotion.discount_amount,
          active: promotion.active,
          promotion_class_type: []
        }
      end

      it_behaves_like 'a successful request'

      it 'returns code information' do
        expect(response.body).to eq(data.to_json)
      end
    end

    context 'invalid params' do
      let(:params) { { code: 'params', match_id: match.id } }

      it_behaves_like 'an unsuccessful request'

      it 'returns false active' do
        expect(response.body).to eq(expected_error.to_json)
      end
    end
  end
end
