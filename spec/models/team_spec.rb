# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :string
#
# Indexes
#
#  index_teams_on_name  (name)
#  index_teams_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Team, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_one :home_stadium }
  it { is_expected.to have_many :matches_as_home_team }
  it { is_expected.to have_many :matches_as_away_team }
  it { is_expected.to have_and_belong_to_many :seasons }
end
