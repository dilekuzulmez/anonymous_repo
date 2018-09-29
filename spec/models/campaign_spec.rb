# == Schema Information
#
# Table name: campaigns
#
#  id                  :integer          not null, primary key
#  code                :string           not null
#  used_with_promotion :boolean          default(FALSE), not null
#  is_active           :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  provider            :integer          not null
#

require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it { is_expected.to validate_presence_of(:code) }
end
