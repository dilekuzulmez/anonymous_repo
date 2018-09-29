# == Schema Information
#
# Table name: transaction_histories
#
#  id                  :integer          not null, primary key
#  order_id            :integer
#  customer_id         :integer
#  request_ip          :string           not null
#  key                 :string           not null
#  status              :integer          not null
#  amount              :decimal(, )      default(0.0), not null
#  response            :hstore
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  opamount            :decimal(, )      default(0.0)
#  discount_amount_123 :decimal(, )      default(0.0)
#
# Indexes
#
#  index_transaction_histories_on_customer_id  (customer_id)
#  index_transaction_histories_on_order_id     (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (order_id => orders.id)
#

require 'rails_helper'

RSpec.describe TransactionHistory, type: :model do
  it { is_expected.to belong_to :customer }
  it { is_expected.to belong_to :order }
end
