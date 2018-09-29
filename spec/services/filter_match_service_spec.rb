require 'rails_helper'

describe FilterMatchService do
  subject(:service) { described_class.new }

  let(:team) { create(:team) }
  let!(:match) { create(:match, start_time: Time.current + 2.days, home_team_id: team.id) }

  describe '#execute' do
    context 'type is UPCOMING' do
      let(:filters) do
        {
          type: '1',
          teams: team.id
        }
      end

      it 'filters UPCOMING matches' do
        result = service.execute(filters)

        expect(result.to_a).to match_array(match)
      end
    end

    context 'type is PLAYED' do
      let(:filters) do
        {
          type: '2',
          teams: team.id
        }
      end

      it 'filters PLAYED matches' do
        result = service.execute(filters)

        expect(result.to_a).to match_array(nil)
      end
    end
  end
end
