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

class Stadium < ApplicationRecord
  audited
  self.table_name = 'stadiums'

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates_presence_of :name

  belongs_to :home_team, class_name: 'Team', foreign_key: :team_id
  has_many :zones, dependent: :delete_all
  has_many :matches, dependent: :nullify

  delegate :name, to: :home_team, prefix: true, allow_nil: true
end
