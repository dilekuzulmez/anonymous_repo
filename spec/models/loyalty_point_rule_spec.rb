# == Schema Information
#
# Table name: loyalty_point_rules
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  point       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  active      :boolean
#  code        :string
#

require 'rails_helper'

RSpec.describe LoyaltyPointRule, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :point }
end
