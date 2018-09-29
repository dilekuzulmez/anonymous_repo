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

FactoryGirl.define do
  factory :match do
    start_time { Faker::Time.forward(23, :morning) }
    round { %w[pre_season semi-final final].sample }

    association :home_team, factory: :team
    association :away_team, factory: :team
    association :season, factory: :season

    stadium { home_team&.home_stadium }

    trait :played do
      start_time { Faker::Time.backward(10, :morning) }
    end

    trait :unknown do
      name { ['Final game', 'Tryout'].sample }
      home_team  nil
      away_team nil
      stadium nil
    end
  end
end
