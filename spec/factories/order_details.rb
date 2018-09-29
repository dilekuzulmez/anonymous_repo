# == Schema Information
#
# Table name: order_details
#
#  id                :integer          not null, primary key
#  order_id          :integer
#  ticket_type_id    :integer
#  quantity          :integer          not null
#  unit_price        :decimal(, )      default(0.0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  match_id          :integer
#  expired_at        :datetime
#  hash_key          :string
#  is_qr_used        :boolean          default(FALSE)
#  qr_code_file_name :string
#
# Indexes
#
#  index_order_details_on_match_id        (match_id)
#  index_order_details_on_order_id        (order_id)
#  index_order_details_on_ticket_type_id  (ticket_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (ticket_type_id => ticket_types.id)
#

FactoryGirl.define do
  factory :order_detail do
    quantity { rand(1..10) }
    unit_price { ticket_type&.price }
    match { create(:match) }
  end
end
