# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  slug        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  code        :string
#
# Indexes
#
#  index_teams_on_name  (name)
#  index_teams_on_slug  (slug) UNIQUE
#

FactoryGirl.define do
  factory :team do
    name { Faker::Name.name }
    code { Faker::University.greek_organization }
    description { Faker::Lorem.paragraph }
    color_1 { Faker::Color.hex_color }
    color_2 { Faker::Color.hex_color }

    association :home_stadium, factory: :stadium
  end
end
