# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  admin_id   :integer
#  viewed_at  :datetime
#  kind       :string(16)
#  message    :string
#  target     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notifications_on_admin_id   (admin_id)
#  index_notifications_on_viewed_at  (viewed_at)
#

FactoryGirl.define do
  factory :notification do
    kind { Notification::KINDS.sample }
    message { Faker::Lorem.sentence }
    target '/matches'
  end
end
