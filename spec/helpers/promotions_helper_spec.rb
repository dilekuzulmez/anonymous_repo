require 'rails_helper'

describe PromotionsHelper do
  describe '.active_tag' do
    let(:result) { helper.active_tag(promotion) }

    context 'when promotion is active' do
      let(:promotion) { build(:promotion, active: true) }

      it 'returns span.label.success tag' do
        expect(result).to eq('<span class="label label-success">active</span>')
      end
    end

    context 'when promotion is inactive' do
      let(:promotion) { build(:promotion, active: false) }

      it 'returns span.label.label-default tag' do
        expect(result).to eq('<span class="label label-default">inactive</span>')
      end
    end
  end
end
