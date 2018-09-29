# == Schema Information
#
# Table name: qr_codes
#
#  id                 :integer          not null, primary key
#  number             :integer
#  used               :boolean          default(FALSE)
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  order_detail_id    :integer
#  qr_type            :integer
#  hash_key           :string
#  match_id           :integer
#  customer_id        :integer
#  expired_at         :datetime
#  home_team_id       :integer
#  ticket_type        :string
#  channel            :string
#  created_at         :datetime
#  updated_at         :datetime
#
# Indexes
#
#  index_qr_codes_on_customer_id      (customer_id)
#  index_qr_codes_on_match_id         (match_id)
#  index_qr_codes_on_order_detail_id  (order_detail_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_detail_id => order_details.id)
#

FactoryGirl.define do
  factory :qr_code do
  end
end
