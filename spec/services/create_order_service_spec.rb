require 'rails_helper'

describe CreateOrderService do
  subject(:service) { described_class.new(order) }

  let!(:match) { create(:match) }
  let!(:ticket_type_std) { create(:ticket_type, code: 'std', match: match) }
  let!(:ticket_type_vip) { create(:ticket_type, code: 'vip', match: match) }
  let(:order_detail_vip) { build(:order_detail, ticket_type: ticket_type_vip, quantity: 2, match: match) }
  let(:order_detail_std) { build(:order_detail, ticket_type: ticket_type_std, quantity: 4, match: match) }
  let(:order_details) { [order_detail_vip, order_detail_std] }
  let(:order) { build(:order, order_details: order_details, kind: :sell) }

  describe '#execute' do
    context 'when order is invalid' do
      let(:order_details) { [order_detail_vip, order_detail_vip] }
      let(:order) { build(:order, order_details: order_details, kind: :sell) }

      it 'doesnt change anything' do
        expect(order.expired_at).to be_nil
        expect(order.order_details.length).to eq(2)
      end
    end

    it 'sets expired_at for unpaid order' do
      service.execute

      expect(Order.last.expired_at).not_to be_nil
    end

    it 'creates new order' do
      expect { service.execute }.to change(Order, :count).by(1)
    end

    context 'different order details for different ticket type' do
      it 'creates 2 order_details' do
        expect { service.execute }.to change(OrderDetail, :count).by(2)
      end

      it 'keeps quantity of 2 order details' do
        service.execute

        expect(OrderDetail.find_by(ticket_type_id: ticket_type_vip.id).quantity).to eq(2)
        expect(OrderDetail.find_by(ticket_type_id: ticket_type_std.id).quantity).to eq(4)
      end
    end
  end
end
