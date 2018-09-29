# == Schema Information
#
# Table name: matches
#
#  id              :integer          not null, primary key
#  stadium_id      :integer
#  home_team_id    :integer
#  away_team_id    :integer
#  round           :string
#  start_time      :datetime         not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  season_id       :integer
#  name            :string
#  home_team_score :integer          default(0)
#  away_team_score :integer          default(0)
#  active          :boolean          default(TRUE)
#
# Indexes
#
#  index_matches_on_away_team_id  (away_team_id)
#  index_matches_on_home_team_id  (home_team_id)
#  index_matches_on_season_id     (season_id)
#  index_matches_on_stadium_id    (stadium_id)
#  index_matches_on_start_time    (start_time)
#
# Foreign Keys
#
#  fk_rails_...  (away_team_id => teams.id) ON DELETE => nullify
#  fk_rails_...  (home_team_id => teams.id) ON DELETE => nullify
#  fk_rails_...  (season_id => seasons.id)
#  fk_rails_...  (stadium_id => stadiums.id)
#

# rubocop:disable all
class Match < ApplicationRecord
  include SeasonsHelper
  MATCH_DURATION_MINUTES = 120
  UPCOMING_MATCH = 1
  PLAYED_MATCH = 2

  audited
  has_associated_audits

  belongs_to :stadium
  belongs_to :season
  validates_presence_of :season_id, unless: :skip_season_validation
  attr_accessor :skip_season_validation
  belongs_to :home_team, class_name: 'Team', foreign_key: :home_team_id
  belongs_to :away_team, class_name: 'Team', foreign_key: :away_team_id

  has_many :ticket_types, dependent: :destroy
  has_many :order_details
  has_many :orders, through: :order_details

  has_many :matchs_promotions
  has_many :promotions, through: :matchs_promotions

  delegate :name, to: :home_team, prefix: true, allow_nil: true
  delegate :name, to: :away_team, prefix: true, allow_nil: true
  delegate :code, to: :home_team, prefix: true, allow_nil: true
  delegate :code, to: :away_team, prefix: true, allow_nil: true

  delegate :name, to: :stadium, prefix: true, allow_nil: true
  delegate :name, to: :season, prefix: true, allow_nil: true

  validates_presence_of :start_time
  validates_presence_of :stadium
  validates_presence_of :home_team
  validates_presence_of :away_team
  validate :team_selection, if: %i[home_team away_team]
  validates_numericality_of :home_team_score, allow_nil: true, greater_than_or_equal_to: 0
  validates_numericality_of :away_team_score, allow_nil: true, greater_than_or_equal_to: 0

  scope :today, -> { where(start_time: (Time.current.beginning_of_day..Time.current.end_of_day)) }
  scope :upcoming_or_playing, lambda {
    where('start_time > ? or (start_time < ? and start_time > ?)', Time.zone.now, Time.zone.now,
          Time.zone.now - MATCH_DURATION_MINUTES.minutes)
  }
  scope :upcoming, lambda {
    where('start_time > ?', Time.current).includes(:home_team, :away_team)
  }
  scope :current_season_with_home_team, lambda { |home_team_id, current_season|
    where('start_time > ?', Time.current + MATCH_DURATION_MINUTES.minutes)
      .where(season: current_season, home_team_id: home_team_id)
  }
  scope :unpaid, -> { where(paid: false) }
  scope :playing, lambda {
    where('start_time < ? and start_time > ?', Time.zone.now, Time.zone.now - MATCH_DURATION_MINUTES.minutes)
  }
  scope :played, -> { where("start_time + INTERVAL '#{MATCH_DURATION_MINUTES} min' < ?", Time.current) }
  scope :in_season, ->(season_id) { where(season_id: season_id) }
  scope :can_sell_ticket, -> { upcoming.where('stadium_id IS NOT NULL') }
  scope :filter_by_teams, ->(teams) { where('home_team_id IN (?) OR away_team_id IN (?)', teams, teams) }
  scope :filter_by_venues, ->(venues) { where('stadium_id IN (?)', venues) }
  scope :filter_upcoming_from, lambda { |from_time|
    where('start_time > ?', from_time > Time.current ? from_time : Time.current)
  }
  scope :filter_upcoming_to, ->(to_time) { where("start_time + '#{MATCH_DURATION_MINUTES} min' < ?", to_time) }
  scope :active, -> { where(active: true) }

  # Check if the game is played or upcoming, return enum value.
  def schedule
    schedule = start_time > Time.current ? UPCOMING_MATCH : PLAYED_MATCH

    schedule
  end

  def total_revenue
    orders.where(paid: true).map(&:total_after_discount).sum
  end

  # An unknown match is when we haven't know 2 competitors yet, usually it is
  # final, semi-final, etc...
  def unknown?
    home_team.nil? && away_team.nil?
  end

  def winner
    return home_team if home_team_score > away_team_score
    away_team if home_team_score < away_team_score
  end

  def name
    "#{home_team_name} vs #{away_team_name}"
  end

  def name_with_time
    "#{home_team_name} vs #{away_team_name} [ #{start_time} ]"
  end

  class TicketAvailability
    attr_reader :code, :quantity, :bought

    def initialize(code:, quantity:, bought:)
      @code = code
      @quantity = quantity
      @bought = bought || 0
    end

    def remaining
      @quantity - @bought
    end
  end

  def remaining_seats_of_type(code)
    ticket_type = ticket_types.find_by_code!(code)

    bought = order_details
             .joins(:order)
             .where('orders.expired_at IS NULL OR orders.expired_at > NOW() OR orders.status = 1')
             .where(ticket_type: ticket_type)
             .sum(:quantity)

    remaining_ticket = ticket_type.quantity - bought
    remaining_ticket.positive? ? remaining_ticket : 0
  end

  def remaining_seats_of_ticket_types(codes)
    codes_param = codes.map { |c| "'#{c}'" }.join(',')

    query = <<-QUERY
 SELECT ticket_types.code, ticket_types.quantity, sum(order_details.quantity) AS bought
 FROM orders
 INNER JOIN order_details ON orders.id = order_details.order_id AND (orders.expired_at IS NULL OR orders.expired_at > NOW())
 RIGHT JOIN ticket_types ON order_details.ticket_type_id = ticket_types.id
 WHERE ticket_types.match_id = #{id}
 AND ticket_types.code in (#{codes_param})
 GROUP BY ticket_types.code, ticket_types.quantity;
    QUERY

    ActiveRecord::Base.connection.exec_query(query).each_with_object({}) do |row, hash|
      hash[row['code']] = TicketAvailability.new(row.symbolize_keys)
    end
  end

  # rubocop:enable

  private

  def team_selection
    errors.add(:away_team, 'can\'t be the same as home team') if home_team.id == away_team.id
  end
end
