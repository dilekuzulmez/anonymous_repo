require 'rails_helper'

describe ZonesHelper do
  describe 'show_zone_custom_hash' do
    let!(:zone) { create(:zone) }

    it 'returns hash with stadium key' do
      hash = helper.show_zone_custom_hash(zone)
      link = link_to(zone.stadium_name, stadium_path(zone.stadium))

      expect(hash[:stadium]).to eq(link)
    end
  end
end
