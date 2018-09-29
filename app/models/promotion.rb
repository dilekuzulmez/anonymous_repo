# == Schema Information
#
# Table name: promotions
#
#  id                :integer          not null, primary key
#  code              :string(32)       not null
#  slug              :string
#  discount_type     :string(32)       not null
#  discount_amount   :decimal(10, 2)   default(0.0), not null
#  active            :boolean          default(FALSE)
#  description       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  quantity          :integer
#  limit_number_used :integer
#  start_date        :date
#  end_date          :date
#
# Indexes
#
#  index_promotions_on_code  (code) UNIQUE
#  index_promotions_on_slug  (slug) UNIQUE
#

class Promotion < ApplicationRecord
  DISCOUNT_TYPES = %w[percent amount].freeze

  audited
  extend Enumerize
  extend FriendlyId
  friendly_id :code, use: :slugged
  has_many :matchs_promotions, dependent: :destroy
  has_many :matches, through: :matchs_promotions

  has_many :customers_promotions, dependent: :destroy

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :discount_amount, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }, if: -> { quantity }
  validates :limit_number_used, numericality: { greater_than_or_equal_to: 0 }, if: -> { limit_number_used }
  validates_presence_of :start_date
  validates_presence_of :end_date
  validate :start_over_end, if: -> { start_date && end_date }

  enumerize :discount_type, in: DISCOUNT_TYPES, default: :percent

  normalize_attribute :code, with: :upcase

  def start_over_end
    errors.add(:start_date, 'Invalid date') if start_date > end_date
  end

  class << self
    def find_by_code(params)
      return if params[:code].blank? || params[:customer_id].blank?

      promotion = find_promotion(params[:code], params[:match_id])

      return promotion if valid?(promotion, params[:customer_id])
    end

    def valid?(promotion, customer_id)
      # Promotion will be invalid if that promotion has quantity less than 0
      # And promotion valid if it's unlimited quantity(quantity = nil) or quantity > 0
      return if promotion&.quantity.present? && promotion.quantity <= 0

      # Promotion will be invalid if a customer use it n times > limit_number_used of each customer
      return promotion unless can_used?(promotion&.id, customer_id, promotion&.limit_number_used)
    end

    def set_condition(code)
      { active: true, code: code.upcase }
    end

    def find_promotion(code, match_id)
      get_single_promotion(code, match_id)
    end

    def get_season_promotion(code)
      Promotion.find_by(set_condition(code))
    end

    # rubocop:disable all
    def get_single_promotion(code, match_id)
      promotions = Promotion.where(set_condition(code)).where('start_date <= ? AND end_date >= ?', Date.current, Date.current)

      if promotions.first&.matches.present?
        promotions = promotions.joins(:matchs_promotions).where('matchs_promotions.match_id = ?', match_id)
      end
      promotions.first
    end

    # Return nil(can use) if that customer can't use a promotion_code
    def can_used?(promotion_id, customer_id, limit_number_used)
      CustomersPromotion.where(promotion_id: promotion_id, customer_id: customer_id)
                        .where('number_used >= ?', limit_number_used).first
    end
  end
end
