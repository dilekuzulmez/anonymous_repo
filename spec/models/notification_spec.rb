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

require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { is_expected.to belong_to :admin }
  it { is_expected.to enumerize(:kind).in(%i[success warning info danger]) }
end
