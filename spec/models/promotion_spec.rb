# == Schema Information
#
# Table name: promotions
#
#  id                :integer          not null, primary key
#  code              :string(32)       not null
#  slug              :string
#  discount_type     :string(32)       not null
#  discount_amount   :decimal(10, 2)   default(0.0), not null
#  active            :boolean          default(FALSE)
#  description       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  quantity          :integer
#  limit_number_used :integer
#  start_date        :date
#  end_date          :date
#
# Indexes
#
#  index_promotions_on_code  (code) UNIQUE
#  index_promotions_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Promotion, type: :model do
  subject { create(:promotion) }

  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  it { is_expected.to validate_presence_of(:discount_amount) }
  it { is_expected.to validate_numericality_of(:discount_amount).is_greater_than_or_equal_to(0) }
  it { is_expected.to normalize_attribute(:code).from('abc').to('ABC') }

  it { is_expected.to enumerize(:discount_type).in(Promotion::DISCOUNT_TYPES).with_default(:percent) }

  describe '.find_by_code' do
    let!(:match) { create(:match) }
    let!(:match_2) { create(:match) }
    let!(:customer) { create(:customer) }

    context 'valid and active promotion code' do
      let!(:promotion) { create(:promotion, :active, code: 'abc') }
      let!(:matchs_promotion) { create(:matchs_promotion, match: match, promotion: promotion) }

      it 'returns promotion code' do
        params = { code: 'abc', match_id: match.id, customer_id: customer.id }
        expect(Promotion.find_by_code(params)).to eq(promotion)
      end

      it 'also doesnt care about code case sensitiveness' do
        params = { code: 'ABC', match_id: match.id, customer_id: customer.id }
        expect(Promotion.find_by_code(params)).to eq(promotion)
      end
    end

    context 'invalid code' do
      let!(:promotion) { create(:promotion, :active, code: 'def') }
      let!(:matches_promotion) { create(:matchs_promotion, match: match_2, promotion: promotion) }

      it 'returns nil' do
        params = { code: 'def', match_id: match.id, customer_id: customer.id }
        expect(Promotion.find_by_code(params)).to be_nil
      end
    end

    context 'inactive code' do
      let!(:promotion) { create(:promotion, code: 'abc') }
      let!(:matches_promotion) { create(:matchs_promotion, match: match_2, promotion: promotion) }

      it 'returns nil' do
        params = { code: 'abc', match_id: match.id, customer_id: customer.id }
        expect(Promotion.find_by_code(params)).to be_nil
      end
    end

    context 'season promotion code' do
      let!(:single_promotion_1) { create(:promotion, :active, code: 'abc') }
      let!(:single_promotion_2) { create(:promotion, :active, code: 'aaa', quantity: 0) }
      let!(:season_promotion_1) { create(:promotion, :active, code: 'ss_1', is_season: true) }
      let!(:season_promotion_2) do
        create(:promotion, :active, code: 'ss_2', is_season: true, limit_number_used: 2)
      end

      it 'returns nil if season promotion not found' do
        params = { code: 'def', match_id: match.id, customer_id: customer.id, is_season: true }
        expect(Promotion.find_by_code(params)).to be_nil
      end

      it 'return season promotion code' do
        params = { code: 'ss_1', match_id: match.id, customer_id: customer.id, is_season: true }
        expect(Promotion.find_by_code(params)).to eq(season_promotion_1)
      end

      it 'return nil if use single promotion code for season ticket' do
        params = { code: 'abc', match_id: match.id, customer_id: customer.id, is_season: true }
        expect(Promotion.find_by_code(params)).to be_nil
      end

      it 'return nil if use season promotion code for single ticket' do
        params = { code: 'ss_1', match_id: match.id, customer_id: customer.id }
        expect(Promotion.find_by_code(params)).to be_nil
      end

      it 'return nil if promotion code is used 2 times' do
        params = { code: 'ss_1', match_id: match.id, customer_id: customer.id, is_season: true }
        expect(Promotion.find_by_code(params)).to eq(season_promotion_1)
        CustomersPromotion.create(customer: customer, promotion: season_promotion_1, number_used: 1)
        expect(Promotion.find_by_code(params)).to be_nil
      end

      it 'return nil if promotion code is used 3 times' do
        params = { code: 'ss_2', match_id: match.id, customer_id: customer.id, is_season: true }
        CustomersPromotion.create(customer: customer, promotion: season_promotion_2, number_used: 2)
        expect(Promotion.find_by_code(params)).to be_nil
      end

      it 'return nil if promotion code has quantity equal 0' do
        params = { code: 'aaa', match_id: match.id, customer_id: customer.id, is_season: true }
        expect(Promotion.find_by_code(params)).to be_nil
      end
    end
  end
end
