# == Schema Information
#
# Table name: leagues
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#  active     :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :league do
    name { Faker::Name.name }
    code { Faker::Name.first_name }
    active { true }
  end
end
