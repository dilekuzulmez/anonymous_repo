require 'rails_helper'

describe StadiumsHelper do
  describe 'show_stadium_custom_hash' do
    subject(:hash) { helper.show_stadium_custom_hash(stadium) }

    context 'when stadium has home_team' do
      let(:stadium) { build(:stadium) }
      let!(:team) { create(:team, home_stadium: stadium) }

      it 'returns hash with url to home_team key' do
        link = link_to(stadium.home_team_name, team_path(stadium.home_team))
        expect(hash[:home_team]).to eq(link)
      end
    end

    context 'when stadium doesnt have home_team' do
      let(:stadium) { create(:stadium) }

      it 'returns hash with N/A as value' do
        expect(hash[:home_team]).to eq('N/A')
      end
    end
  end
end
