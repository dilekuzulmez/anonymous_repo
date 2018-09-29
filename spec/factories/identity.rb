# == Schema Information
#
# Table name: identities
#
#  id          :integer          not null, primary key
#  uid         :string
#  provider    :string
#  customer_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_identities_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
FactoryGirl.define do
  factory :identity do
    association :customer, factory: :customer

    uid { rand(1..10) }
    provider { :w[account_kit, facebook].sample }
  end
end
