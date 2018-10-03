# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  customer_id      :integer
#  shipping_address :string
#  created_by_id    :integer
#  created_by_type  :string
#  paid             :boolean          default(FALSE)
#  promotion_code   :string(32)
#  discount_amount  :decimal(, )      default(0.0), not null
#  discount_type    :string(128)
#  expired_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  purchased_date   :datetime
#  sale_channel     :string           default("COD")
#  status           :integer
#  phone_number     :string
#
# Indexes
#
#  index_orders_on_created_by_id_and_created_by_type  (created_by_id,created_by_type)
#  index_orders_on_customer_id                        (customer_id)
#

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to belong_to :customer }
  it { is_expected.to belong_to(:created_by) }

  it { is_expected.to enumerize(:kind).in(:invitation, :sell, :ticket_box).with_default(:sell) }

  describe 'validates promotion_code' do
    let(:promotion) { create(:promotion, :active, code: 'abc') }
    let(:match) { create(:match) }
    let!(:ticket_type) { create(:ticket_type, match: match) }
    let(:order_detail) { build(:order_detail, ticket_type: ticket_type, match: match) }
    let(:promotion_code) { promotion.code }
    let!(:customer) { create(:customer) }
    let(:order) do
      build(:order, customer: customer, promotion_code: promotion_code, order_details: [order_detail])
    end

    let!(:matchs_promotion) { create(:matchs_promotion, match: match, promotion: promotion) }

    context 'valid promotion code' do
      it 'returns valid' do
        expect(order).to be_valid
      end
    end

    context 'empty promotion code' do
      let(:promotion_code) { '' }

      it 'returns valid' do
        expect(order).to be_valid
      end
    end

    context 'invalid promotion code' do
      let(:promotion_code) { 'def' }

      it 'returns invalid' do
        expect(order).not_to be_valid
      end
    end
  end

  describe '#calculate_expired_at' do
    let(:start_at) { Time.local(2017, 10, 10, 19) }
    let(:paid) { false }
    let(:match) { create(:match, start_time: start_at) }
    let(:order_detail) { build(:order_detail, match: match) }
    let(:order) { build(:order, order_details: [order_detail], paid: paid, kind: :sell) }

    before do
      Timecop.freeze(Time.local(2017, 9, 10, 7))

      order.calculate_expired_at
    end

    after { Timecop.return }

    context 'when order is paid' do
      let(:paid) { true }

      it 'return expired at time' do
        expect(order.expired_at).to eq(order.order_details.first.match.start_time + 2.hours)
      end
    end

    context 'unpaid order' do
      it 'sets expired_at to 2 days after ordered' do
        expect(order.expired_at).to eq(Time.current + 2.days)
      end
    end
  end

  describe '#total_xxx' do
    let(:match) { create(:match) }
    let!(:vip_ticket_type) { create(:ticket_type, code: 'vip', quantity: 10, price: '200000', match: match) }
    let!(:std_ticket_type) { create(:ticket_type, code: 'std', quantity: 10, price: '100000', match: match) }
    let(:vip_order) { build(:order_detail, ticket_type: vip_ticket_type, quantity: 2, match: match) }
    let(:std_order) { build(:order_detail, ticket_type: std_ticket_type, quantity: 5, match: match) }
    let(:order) { build(:order, order_details: [vip_order, std_order]) }
    let(:sum) { 200_000 * 2 + 100_000 * 5 }

    describe '#total_before_discount' do
      it 'returns total amount of the order' do
        expect(order.total_before_discount).to eq(sum)
      end
    end

    describe '#total_after_discount' do
      context 'has percentage promotion' do
        let(:order) do
          build(:order,
                order_details: [vip_order, std_order],
                discount_amount: '10.0',
                discount_type: 'percent')
        end

        it 'returns amount after discount' do
          expect(order.total_after_discount).to eq(sum * 0.9)
        end
      end

      context 'has amount promotion' do
        let(:order) do
          build(:order,
                order_details: [vip_order, std_order],
                discount_amount: '100000',
                discount_type: 'amount')
        end

        it 'returns amount after discount' do
          expect(order.total_after_discount).to eq(sum - 100_000)
        end
      end
    end
  end
end
