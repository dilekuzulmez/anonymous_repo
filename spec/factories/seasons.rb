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

FactoryGirl.define do
  factory :season do
    name { Faker::Name.name }
    is_active { true }
    duration { (Date.today..Date.today + 3.months) }

    teams { create_list(:team, 7) }
    league
    amount_matches { 2 }
  end
end
