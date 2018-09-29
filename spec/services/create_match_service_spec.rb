require 'rails_helper'

describe CreateMatchService do
  subject(:service) { described_class.new }

  let(:stadium) { create(:stadium) }
  let(:home_team) { create(:team, home_stadium: stadium) }
  let(:zones) { create_list(:zone, 5, stadium: stadium) }

  let(:execution) { service.execute(attributes) }

  describe '#execute' do
    context 'valid match' do
      let(:attributes) do
        attributes_for(:match).merge(home_team: home_team, stadium: stadium, away_team: create(:team))
      end

      it 'creates 1 record in db' do
        expect { execution }.to change(Match, :count).by(1)
      end

      it 'creates ticket_types which are copied from zones' do
        expect { execution }.to change(TicketType, :count).by(zones.count)
      end
    end

    context 'invalid match' do
      let(:attributes) { attributes_for(:match) }

      it 'returns invalid record' do
        match = execution

        expect(match).not_to be_valid
      end

      it 'does not create any records' do
        expect { execution }.not_to change(Match, :count)
        expect { execution }.not_to change(TicketType, :count)
      end
    end
  end
end
