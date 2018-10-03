# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  customer_id      :integer
#  shipping_address :string
#  created_by_id    :integer
#  created_by_type  :string
#  paid             :boolean          default(FALSE)
#  promotion_code   :string(32)
#  discount_amount  :decimal(, )      default(0.0), not null
#  discount_type    :string(128)
#  expired_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  purchased_date   :datetime
#  sale_channel     :string           default("COD")
#  status           :integer
#  phone_number     :string
#
# Indexes
#
#  index_orders_on_created_by_id_and_created_by_type  (created_by_id,created_by_type)
#  index_orders_on_customer_id                        (customer_id)
#

# rubocop:disable Metrics/ClassLength
class Order < ApplicationRecord
  extend Enumerize
  audited
  belongs_to :customer
  belongs_to :created_by, polymorphic: true

  attr_accessor :home_team_id, :total_price

  EARLY_BIRD_THREDSHOLD_IN_DAY = 3

  has_many :order_details, dependent: :destroy
  has_many :matches, through: :order_details
  has_one :transaction_history

  has_associated_audits
  accepts_nested_attributes_for :order_details, allow_destroy: true

  # after_create :send_push, unless: -> { paid }

  validate :order_details_existence
  validate :check_promotion_code, if: -> { promotion_code.present? }, on: :create

  enumerize :status, in: { canceled: 0, completed: 1, pending: 2 }, default: :pending

  delegate :name, to: :customer, allow_nil: true, prefix: true

  before_save :set_status, only: %i[create update]

  scope :by_customer_name, lambda { |name|
    joins(:customer)
      .where('customers.first_name ILIKE ? or customers.last_name ILIKE ?',
             "#{name}%",
             "#{name}%")
  }

  scope :by_phone, lambda { |phone|
    joins(:customer).where('customers.phone_number LIKE ?', "#{phone.phony_normalized}%")
  }

  scope :by_paid, ->(paid) { where(paid: paid) }

  scope :by_purchased_date, lambda { |range|
    where(purchased_date: range[0]..range[1])
  }

  scope :sort_by_status, lambda { |type|
    joins(:order_details).joins(:matches).includes(:order_details)
                         .order("matches.start_time #{type}")
  }

  # rubocop:disable Metrics/AbcSize
  def calculate_expired_at
    sort_details = order_details.sort { |x, y| x.match.start_time <=> y.match.start_time }

    if never_expires?
      last_match = sort_details.last.match
      self.expired_at = last_match.start_time + 2.hours
      return
    end

    # Order is gonna expire if unpaid from order created
    self.expired_at = Time.current + 2.days
  end

  # rubocop:enable

  def total_after_discount
    sum = total_before_discount
    case discount_type
    when 'percent'
      sum *= (1 - (discount_amount / 100))
    when 'amount'
      sum -= discount_amount
    end
    sum
  end

  def total_before_discount
    order_details.reduce(0) do |total, detail|
      total += detail.quantity * detail.unit_price
      total
    end
  end

  def ticket_type_of_season
    order_details.first.ticket_type
  end

  def quantity
    order_details.first.quantity
  end

  def single_match
    order_details.first&.match || Match.new
  end

  def promotion
    # season ticket can not use promotion code
    @promotion ||= Promotion.find_by_code(promotion_params)

    return unless @promotion
    dump_promotion
    @promotion
  end

  private

  def order_details_existence
    errors.add(:base, 'Must have at least 1 order details') if order_details.empty?
  end

  def never_expires?
    paid
  end

  def dump_promotion
    self.discount_amount = @promotion.discount_amount
    self.discount_type = @promotion.discount_type
  end

  def check_promotion_code
    errors.add(:promotion_code, 'is invalid') if promotion.nil?
  end

  def set_status
    self.status = :completed if paid == true
  end

  def promotion_params
    { code: promotion_code, match_id: single_match.id, customer_id: customer_id }
  end

  # rubocop:disable LineLength

  class << self
    def total_paid(type, start_day = nil, end_day = nil)
      if start_day && end_day && start_day < end_day
        where(sale_channel: type, paid: true).where('created_at >= ? AND created_at <= ?', start_day, end_day)
      else
        where(sale_channel: type, paid: true)
      end
    end
  end
end
