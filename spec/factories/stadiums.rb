# == Schema Information
#
# Table name: stadiums
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  address    :string
#  contact    :string
#  slug       :string
#  team_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_stadiums_on_name     (name)
#  index_stadiums_on_slug     (slug) UNIQUE
#  index_stadiums_on_team_id  (team_id)
#

FactoryGirl.define do
  factory :stadium do
    name { Faker::Name.name }
    address { Faker::Address.street_address }
    contact { Faker::PhoneNumber.phone_number }
  end
end
