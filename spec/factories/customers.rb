# == Schema Information
#
# Table name: customers
#
#  id           :integer          not null, primary key
#  email        :string
#  first_name   :string
#  last_name    :string
#  gender       :string(32)
#  birthday     :date
#  phone_number :string(32)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  address      :hstore
#
# Indexes
#
#  index_customers_on_email_and_phone_number  (email,phone_number) UNIQUE
#

FactoryGirl.define do
  factory :customer do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender { %w[male female].sample }
    birthday { Faker::Date.birthday(18, 65) }
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
