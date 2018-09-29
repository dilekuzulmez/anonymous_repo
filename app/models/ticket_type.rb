# == Schema Information
#
# Table name: ticket_types
#
#  id         :integer          not null, primary key
#  match_id   :integer          not null
#  zone_id    :integer
#  quantity   :integer          not null
#  code       :string           not null
#  slug       :string
#  price      :decimal(, )      default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  class_type :integer          default(NULL), not null
#
# Indexes
#
#  index_ticket_types_on_match_id           (match_id)
#  index_ticket_types_on_match_id_and_code  (match_id,code) UNIQUE
#  index_ticket_types_on_slug               (slug) UNIQUE
#  index_ticket_types_on_zone_id            (zone_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (zone_id => zones.id)
#

class TicketType < ApplicationRecord
  audited associated_with: :match
  extend FriendlyId
  friendly_id :code, use: :slugged

  belongs_to :match
  belongs_to :zone

  validates :code, presence: true, uniqueness: { scope: :match_id, case_sensitive: false }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :match, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  normalize_attribute :code, with: :upcase

  enum class_type: { 'Standard': 1, 'Premium': 2, 'VIP': 3 }

  def self.new_from_zone(zone)
    raise ArgumentError, 'zone must not be nil' if zone.nil?
    TicketType.new(zone: zone, code: zone.code, price: zone.price, quantity: zone.capacity,
                   class_type: zone.zone_type)
  end
end
