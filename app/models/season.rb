# == Schema Information
#
# Table name: seasons
#
#  id         :integer          not null, primary key
#  name       :string
#  duration   :daterange        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_active  :boolean          default(FALSE)
#

class Season < ApplicationRecord
  include ApplicationHelper
  include DurationParseConcern
  audited
  validates :name, uniqueness: true
  validates_presence_of :name

  has_many :matches
  has_and_belongs_to_many :teams

  validates_presence_of :duration
  scope :active, -> { where(is_active: true) }

  validate :match_by_season, on: %i[update create]

  def match_by_season
    matches.update_all(active: is_active)
  end
end
