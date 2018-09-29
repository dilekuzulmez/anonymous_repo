# == Schema Information
#
# Table name: combos
#
#  id          :integer          not null, primary key
#  code        :string
#  ticket_type :string
#  description :text
#  price       :decimal(, )
#  is_active   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :combo do
    code 'MyString'
    description 'MyText'
    ticket_type 'MyText'
    price 9.99
    is_active true
  end
end
