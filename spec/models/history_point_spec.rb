# == Schema Information
#
# Table name: history_points
#
#  id                    :integer          not null, primary key
#  customer_id           :integer
#  loyalty_point_rule_id :integer
#  point                 :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  survey_id             :integer
#  order_id              :integer
#  name                  :string
#
# Indexes
#
#  index_history_points_on_customer_id            (customer_id)
#  index_history_points_on_loyalty_point_rule_id  (loyalty_point_rule_id)
#  index_history_points_on_order_id               (order_id)
#  index_history_points_on_survey_id              (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (loyalty_point_rule_id => loyalty_point_rules.id)
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (survey_id => surveys.id)
#

require 'rails_helper'

RSpec.describe HistoryPoint, type: :model do
  it { is_expected.to belong_to :customer }
  it { is_expected.to belong_to :loyalty_point_rule }
  it { is_expected.to belong_to :survey }
  it { is_expected.to belong_to :order }
end
