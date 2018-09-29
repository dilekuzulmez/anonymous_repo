# == Schema Information
#
# Table name: surveys
#
#  id          :integer          not null, primary key
#  name        :string
#  link        :string
#  description :text
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :survey do
    name { Faker::Name.name }
    link { Faker::Name.name }
    description 'Survey description'
    active true
  end
end
