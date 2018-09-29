# == Schema Information
#
# Table name: seasons
#
#  id         :integer          not null, primary key
#  name       :string
#  duration   :daterange        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_active  :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Season, type: :model do
  it { is_expected.to have_many :matches }
  it { is_expected.to have_and_belong_to_many :teams }
  it { is_expected.to validate_presence_of :duration }
end
