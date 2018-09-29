# == Schema Information
#
# Table name: promotions
#
#  id                :integer          not null, primary key
#  code              :string(32)       not null
#  slug              :string
#  discount_type     :string(32)       not null
#  discount_amount   :decimal(10, 2)   default(0.0), not null
#  active            :boolean          default(FALSE)
#  description       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  quantity          :integer
#  limit_number_used :integer
#  start_date        :date
#  end_date          :date
#
# Indexes
#
#  index_promotions_on_code  (code) UNIQUE
#  index_promotions_on_slug  (slug) UNIQUE
#

FactoryGirl.define do
  factory :promotion do
    sequence(:code) { |n| "PROMO_#{n}" }
    discount_type { %w[percent amount].sample }
    discount_amount { rand(1..100) }
    limit_number_used 1
    quantity 50
    is_season false
    start_date { Date.current }
    end_date { Date.current }

    trait :active do
      active true
    end
  end
end
