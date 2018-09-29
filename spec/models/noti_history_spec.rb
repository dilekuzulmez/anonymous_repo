# == Schema Information
#
# Table name: noti_histories
#
#  id          :integer          not null, primary key
#  customer_id :integer
#  title       :string
#  body        :string
#  status      :boolean          default(FALSE)
#  seen        :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_noti_histories_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#

require 'rails_helper'

RSpec.describe NotiHistory, type: :model do
  it { is_expected.to belong_to :customer }
end
