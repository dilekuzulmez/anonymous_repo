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

class Team < ApplicationRecord
  audited

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates_presence_of :name

  # home stadium
  has_one :home_stadium, class_name: 'Stadium', inverse_of: :home_team
  has_many :matches_as_home_team, class_name: 'Match', foreign_key: :home_team_id, inverse_of: :home_team
  has_many :matches_as_away_team, class_name: 'Match', foreign_key: :away_team_id, inverse_of: :away_team

  has_and_belongs_to_many :seasons
end
