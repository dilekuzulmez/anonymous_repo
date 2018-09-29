# == Schema Information
#
# Table name: versions
#
#  id          :integer          not null, primary key
#  number      :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  os          :integer
#

FactoryGirl.define do
  factory :version do
    number '1.5.3'
    description 'MyText'
    os 'IOS'
  end
end
