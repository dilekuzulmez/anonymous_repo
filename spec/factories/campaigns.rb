# == Schema Information
#
# Table name: campaigns
#
#  id                  :integer          not null, primary key
#  code                :string           not null
#  used_with_promotion :boolean          default(FALSE), not null
#  is_active           :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  provider            :integer          not null
#

FactoryGirl.define do
  factory :campaign do
    code { Faker::Name.first_name }
    used_with_promotion true
    is_active true
  end
end
