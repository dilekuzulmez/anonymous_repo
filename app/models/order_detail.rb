# == Schema Information
#
# Table name: order_details
#
#  id                :integer          not null, primary key
#  order_id          :integer
#  ticket_type_id    :integer
#  quantity          :integer          not null
#  unit_price        :decimal(, )      default(0.0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  match_id          :integer
#  expired_at        :datetime
#  hash_key          :string
#  is_qr_used        :boolean          default(FALSE)
#  qr_code_file_name :string
#
# Indexes
#
#  index_order_details_on_match_id        (match_id)
#  index_order_details_on_order_id        (order_id)
#  index_order_details_on_ticket_type_id  (ticket_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (ticket_type_id => ticket_types.id)
#

class OrderDetail < ApplicationRecord
  MATCH_DURATION_MINUTES = 120
  audited associated_with: :order
  belongs_to :order
  belongs_to :match
  belongs_to :ticket_type
  has_one :customer, through: :order
  validates :order, presence: true
  validates :ticket_type_id, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :ticket_type_availability, if: %i[order ticket_type]
  validates :match_id, presence: true
  after_create :assign_qr_code

  scope :qr_, -> { where(start_time: (Time.current..Time.current + MATCH_DURATION_MINUTES.minutes)) }
  scope :upcoming_match, lambda {
    joins(:match).where('matches.start_time > ? OR (matches.start_time < ? AND matches.start_time > ?)',
                        Time.zone.now, Time.zone.now, Time.zone.now - MATCH_DURATION_MINUTES.minutes)
                 .order('matches.start_time ASC')
  }
  scope :invalid_orders, lambda {
    joins(:match).order('matches.start_time ASC')
  }

  delegate :code, to: :ticket_type, prefix: true
  delegate :ticket_types, to: :match, allow_nil: true

  def assign_qr_code
    CreateQrCodeService.new.create_qr_code(self)
  end

  private

  def ticket_type_availability
    return unless match
    remaining = match.remaining_seats_of_type(ticket_type.code)
    quantity = self.quantity || 0

    errors.add(:quantity, "is too big. Only have #{remaining} left") if (remaining - quantity).negative?
  end
end
