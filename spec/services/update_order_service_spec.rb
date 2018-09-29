require 'rails_helper'

describe UpdateOrderService do
  subject(:service) { described_class.new(order, update_params) }

  let!(:match) { create(:match) }
  let!(:ticket_type_std) { create(:ticket_type, code: 'std', match: match) }
  let(:order_detail) { build(:order_detail, ticket_type: ticket_type_std, quantity: 4, match: match) }
  let(:order) do
    create(:order_with_details, order_details: [order_detail], kind: :sell, expired_at: Time.current + 1.week)
  end
  let(:update_params) { { paid: true } }

  describe '#execute' do
    context 'order not paid' do
      it 'update with params paid false' do
        update_params[:paid] = false
        service.execute

        expect(order.purchased_date).to be_nil
      end

      it 'update with params paid true' do
        service.execute

        expect(order.purchased_date.nil?).to be false
      end
    end

    context 'order is paid' do
      it 'return expired at time after starting match 3 hour' do
        service.execute
        expect(order.reload.expired_at).to eq(order.order_details.first.match.start_time + 2.hours)
      end
    end
  end
end
