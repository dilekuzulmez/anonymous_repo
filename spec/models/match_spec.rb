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

require 'rails_helper'

RSpec.describe Match, type: :model do
  it { is_expected.to belong_to :stadium }
  it { is_expected.to belong_to :home_team }
  it { is_expected.to belong_to :away_team }
  it { is_expected.to have_many :ticket_types }
  it { is_expected.to have_many :order_details }
  it { is_expected.to have_many :orders }

  it { is_expected.to validate_presence_of :start_time }

  describe 'validate name' do
    context 'known competitors match' do
      subject { build(:match) }

      it { is_expected.not_to validate_presence_of :name }
      it { is_expected.to validate_presence_of :stadium }
    end
  end

  describe '.winner' do
    let(:match) { create :match, home_team_score: home_team_score, away_team_score: away_team_score }

    context 'home team got higher score' do
      let(:away_team_score) { 10 }
      let(:home_team_score) { 30 }

      it 'returns home team' do
        expect(match.winner).to eq(match.home_team)
      end
    end

    context 'away team got higher score' do
      let(:home_team_score) { 10 }
      let(:away_team_score) { 40 }

      it 'returns away team' do
        expect(match.winner).to eq(match.away_team)
      end
    end
  end

  describe 'validate team selection' do
    let!(:team) { create(:team) }

    it 'is invalid when both team are the same' do
      match = build(:match, home_team: team, away_team: team)
      expect(match).not_to be_valid
      expect(match.errors[:away_team]).to eq(['can\'t be the same as home team'])
    end
  end

  describe 'match start_time scope' do
    # before { Timecop.freeze(Time.local(2017, 0o7, 30, 1)) }
    # after { Timecop.return }

    let!(:upcoming_match) { create(:match, start_time: Time.current + 1.week) }
    let!(:playing_match) { create(:match, start_time: Time.zone.now) }
    let!(:played_match) do
      match = build(:match, start_time: Time.current - 5.days)
      match.save(validate: false)
      match
    end

    describe '.upcoming' do
      it 'returns upcoming_match' do
        expect(Match.upcoming).to contain_exactly(upcoming_match)
      end
    end

    describe '.playing' do
      it 'returns playing match' do
        expect(Match.playing).to contain_exactly(playing_match)
      end
    end

    describe '.played' do
      it 'returns played match' do
        expect(Match.played).to contain_exactly(played_match)
      end
    end
  end

  describe 'match filter scope' do
    let(:stadium) { create(:stadium) }
    let(:team) { create(:team) }
    let!(:match) do
      create(:match, stadium_id: stadium.id, home_team_id: team.id, start_time: Time.current + 1.hour)
    end

    describe 'by teams' do
      it 'returns match' do
        expect(Match.filter_by_teams(team.id)).to contain_exactly(match)
      end
    end

    describe 'by venues' do
      it 'returns match' do
        expect(Match.filter_by_venues(stadium.id)).to contain_exactly(match)
      end
    end

    describe 'by time start from' do
      it 'returns match' do
        expect(Match.filter_upcoming_from(Time.current)).to contain_exactly(match)
      end
    end

    describe 'by time start to' do
      it 'returns match' do
        expect(Match.filter_upcoming_to(Time.current + 3.hour)).to contain_exactly(match)
      end
    end
  end

  describe '#name' do
    it 'returns team name if specified' do
      match = create(:match)
      expect(match.name).to eq("#{match.home_team_name} vs #{match.away_team_name}")
    end
  end

  describe '#remaining_seats_of_ticket_types' do
    let(:match) { create(:match) }
    let!(:ticket_type) { create(:ticket_type, code: 'A1', quantity: 10, match: match) }
    let(:code) { 'A1' }
    let(:result) { match.remaining_seats_of_ticket_types([code]) }
    let(:order_detail) { build(:order_detail, ticket_type: ticket_type, quantity: 1, match: match) }
    let!(:order) { build(:order, order_details: [order_detail], expired_at: Time.current + 3.days) }

    before do
      Timecop.freeze(Time.local(2017, 9, 10, 20))
    end

    after { Timecop.return }

    context 'no order yet' do
      it 'returns a hash with key is the code' do
        expect(result).to have_key(code)
      end

      it 'returns hash whose value has info about quantity and bought' do
        value = result[code]
        expect(value.bought).to eq(0)
        expect(value.quantity).to eq(10)
      end
    end

    context 'has order details' do
      before do
        order_detail.save
      end

      it 'returns hash whose fisrt item has bought = 9' do
        value = result[code]
        expect(value.bought).to eq(1)
      end
    end

    context 'someone ordered before but expired' do
      before do
        create(:order, order_details: [order_detail], expired_at: 2.days.ago)
      end

      it 'doesnt count expired order and returns correct value' do
        value = result[code]
        expect(value.bought).to eq(0)
      end
    end

    context 'ask for more than 1 code' do
      let(:code_2) { 'VIP' }
      let!(:other_ticket_type) { create(:ticket_type, code: code_2, quantity: 10, match: match) }
      let(:result) { match.remaining_seats_of_ticket_types([code, code_2]) }

      before do
        create(:order_detail, order: order, ticket_type: other_ticket_type, quantity: 2, match: match)
      end

      it 'returns hash with 2 keys' do
        expect(result).to have_key(code)
        expect(result).to have_key(code_2)
      end

      it 'calculates correct remaining' do
        expect(result[code].remaining).to eq(9)
        expect(result[code_2].remaining).to eq(8)
      end
    end
  end

  describe '#remaining_seats_of_type' do
    let(:match) { create(:match) }
    let(:code) { 'A1' }
    let!(:ticket_type) { create(:ticket_type, code: code, match: match, quantity: 10) }
    let(:result) { match.remaining_seats_of_type(code) }

    context 'unknown code' do
      let(:code) { 'b' }

      it 'raises exception' do
        expect { result }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'no order yet' do
      it 'returns ticket_type quantity' do
        expect(result).to eq(10)
      end
    end

    context 'with order' do
      let!(:order_detail) { build(:order_detail, ticket_type: ticket_type, quantity: 2, match: match) }
      let!(:order) { create(:order, order_details: [order_detail], expired_at: Time.current + 3.days) }

      it 'returns remaining tickets' do
        expect(result).to eq(8)
      end

      context 'has expired order' do
        before do
          Timecop.freeze(Time.local(2017, 9, 10, 10))

          order_detail = build(:order_detail, ticket_type: ticket_type, quantity: 3, match: match)
          create(:order, order_details: [order_detail], expired_at: 3.days.ago)
        end

        after { Timecop.return }

        it 'doesnt count expired order' do
          expect(result).to eq(8)
        end
      end
    end
  end

  describe Match::TicketAvailability do
    describe '#remaining' do
      subject(:match_availability) { Match::TicketAvailability.new(code: 'A1', quantity: 10, bought: 1) }

      it 'returns quantity - bought' do
        expect(match_availability.remaining).to eq(9)
      end
    end
  end

  describe '.can_sell_ticket' do
    let(:start_time) { Time.current + 3.months }

    context 'match happended in the past' do
      before do
        match = build(:match, :played)
        match.save(validate: false)
      end

      it 'is not returned in query' do
        expect(Match.can_sell_ticket).to be_empty
      end
    end

    context 'not play yet and have stadium' do
      let!(:match) { create(:match) }

      it 'returns match' do
        expect(Match.can_sell_ticket).to contain_exactly(match)
      end
    end
  end
end
