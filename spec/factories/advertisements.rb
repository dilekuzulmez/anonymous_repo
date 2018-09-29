# == Schema Information
#
# Table name: advertisements
#
#  id                 :integer          not null, primary key
#  promotion_id       :integer
#  title              :string
#  duration           :daterange
#  description        :text
#  active             :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  priority           :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :advertisement do
    title 'Hello'
    duration Date.today..Date.today + 2.months
    description 'Hello World'
    active true

    trait :promotion do
      promotion
    end
  end
end
