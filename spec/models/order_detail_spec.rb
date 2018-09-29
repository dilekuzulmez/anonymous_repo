# == Schema Information
#
# Table name: order_details
#
#  id                :integer          not null, primary key
#  order_id          :integer
#  ticket_type_id    :integer
#  quantity          :integer          not null
#  unit_price        :decimal(, )      default(0.0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  match_id          :integer
#  expired_at        :datetime
#  hash_key          :string
#  is_qr_used        :boolean          default(FALSE)
#  qr_code_file_name :string
#
# Indexes
#
#  index_order_details_on_match_id        (match_id)
#  index_order_details_on_order_id        (order_id)
#  index_order_details_on_ticket_type_id  (ticket_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (ticket_type_id => ticket_types.id)
#

require 'rails_helper'

RSpec.describe OrderDetail, type: :model do
  it { is_expected.to belong_to :order }
  it { is_expected.to belong_to :ticket_type }
  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_presence_of(:ticket_type_id) }
  it { is_expected.to validate_presence_of(:order) }
  it { is_expected.to validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  it { is_expected.to validate_presence_of(:unit_price) }
  it { is_expected.to validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }

  describe 'validates ticket availability' do
    let(:match) { create(:match) }
    let!(:ticket_type) { create(:ticket_type, code: 'A1', quantity: 10, match: match) }
    let(:order_detail) { build(:order_detail, quantity: quantity, ticket_type: ticket_type, match: match) }
    let!(:order) { build(:order, order_details: [order_detail]) }

    before do
      other_order_detail = build(:order_detail, quantity: 5, ticket_type: ticket_type, match: match)
      create(:order, order_details: [other_order_detail])
    end

    context 'still have tickets in stock' do
      let(:quantity) { 2 }

      it 'returns valid' do
        expect(order_detail).to be_valid
      end
    end

    context 'out of stock' do
      let(:quantity) { 6 }

      it 'returns invalid' do
        expect(order_detail).not_to be_valid
      end

      it 'sets error message' do
        order_detail.validate
        expect(order_detail.errors[:quantity]).to contain_exactly('is too big. Only have 5 left')
      end
    end
  end
end
