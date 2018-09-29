# == Schema Information
#
# Table name: loyalty_point_rules
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  point       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  active      :boolean
#  code        :string
#

FactoryGirl.define do
  factory :loyalty_point_rule do
    code 'UDP'
    name 'update profile'
    description 'add 10 points after updated profile'
    point 10
  end
end
