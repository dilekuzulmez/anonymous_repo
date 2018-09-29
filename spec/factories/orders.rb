# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  customer_id      :integer
#  shipping_address :string
#  created_by_id    :integer
#  created_by_type  :string
#  paid             :boolean          default(FALSE)
#  promotion_code   :string(32)
#  discount_amount  :decimal(, )      default(0.0), not null
#  discount_type    :string(128)
#  expired_at       :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  purchased_date   :datetime
#  sale_channel     :string           default("COD")
#  status           :integer
#
# Indexes
#
#  index_orders_on_created_by_id_and_created_by_type  (created_by_id,created_by_type)
#  index_orders_on_customer_id                        (customer_id)
#

FactoryGirl.define do
  factory :order do
    kind { :sell }
    paid { false }
    # order_details { build_list(:order_detail, 1, ticket_type: create(:ticket_type, match: match)) }

    factory :order_with_details do
      # transient do
      #   order_details_count 3
      # end
      #
      # after(:create) do |order, evaluator|
      #   create_list(:order_detail, evaluator.order_details_count,
      #               order: order,
      #               ticket_type: create(:ticket_type, match: order.match))
      # end
    end
  end
end
