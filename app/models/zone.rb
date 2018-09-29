# == Schema Information
#
# Table name: zones
#
#  id          :integer          not null, primary key
#  code        :string           not null
#  description :string
#  capacity    :integer          default(0), not null
#  price       :decimal(, )      default(0.0), not null
#  slug        :string
#  stadium_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  zone_type   :integer          default("Standard"), not null
#
# Indexes
#
#  index_zones_on_code_and_stadium_id  (code,stadium_id) UNIQUE
#  index_zones_on_slug                 (slug) UNIQUE
#  index_zones_on_stadium_id           (stadium_id)
#
# Foreign Keys
#
#  fk_rails_...  (stadium_id => stadiums.id)
#

class Zone < ApplicationRecord
  audited
  extend FriendlyId
  friendly_id :code, use: :slugged

  validates_presence_of :code
  validates_presence_of :price
  validates_presence_of :capacity

  validates_uniqueness_of :code, scope: :stadium_id, case_sensitive: false

  belongs_to :stadium

  delegate :name, to: :stadium, prefix: true

  normalize_attribute :code, with: :upcase

  enum zone_type: { 'Standard': 0, 'Premium': 1, 'VIP': 2 }
end
