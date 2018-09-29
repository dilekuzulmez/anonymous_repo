# == Schema Information
#
# Table name: zones
#
#  id          :integer          not null, primary key
#  code        :string           not null
#  description :string
#  capacity    :integer          default(0), not null
#  price       :decimal(, )      default(0.0), not null
#  slug        :string
#  stadium_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  zone_type   :integer          default("Standard"), not null
#
# Indexes
#
#  index_zones_on_code_and_stadium_id  (code,stadium_id) UNIQUE
#  index_zones_on_slug                 (slug) UNIQUE
#  index_zones_on_stadium_id           (stadium_id)
#
# Foreign Keys
#
#  fk_rails_...  (stadium_id => stadiums.id)
#

FactoryGirl.define do
  factory :zone do
    sequence(:code) { |n| "zone_#{n}" }
    description { Faker::Lorem.sentence }
    price { Faker::Number.decimal(2) }
    capacity { Faker::Number.number(3) }

    association :stadium, factory: :stadium
    association :gate, factory: :gate
  end
end
