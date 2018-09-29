# == Schema Information
#
# Table name: stadiums
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string
#  contact    :string
#  slug       :string
#  team_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_stadiums_on_name     (name)
#  index_stadiums_on_slug     (slug) UNIQUE
#  index_stadiums_on_team_id  (team_id)
#

require 'rails_helper'

RSpec.describe Stadium, type: :model do
  it { is_expected.to validate_presence_of :name }

  it { is_expected.to belong_to :home_team }
  it { is_expected.to have_many :zones }
  it { is_expected.to have_many :matches }

  describe '#home_team_name' do
    it "returns home_team's name" do
      team = create(:team)
      stadium = create(:stadium, home_team: team)

      expect(stadium.home_team_name).to eq(team.name)
    end
  end
end
