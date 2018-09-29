require 'rails_helper'

describe ApplicationHelper do
  describe 'guard_link' do
    context 'empty result' do
      it 'returns empty string if not specify fallback value' do
        result = helper.guard_link(nil) { 'link' }
        expect(result).to eq('')
      end

      it 'returns custom fallback value if specify' do
        result = helper.guard_link(nil, 'n/a') { 'link' }
        expect(result).to eq('n/a')
      end
    end

    it 'returns block result for non-empty resource' do
      result = helper.guard_link(1) { 'link' }
      expect(result).to eq('link')
    end
  end
end
