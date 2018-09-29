# == Schema Information
#
# Table name: leagues
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#  active     :boolean          default(FALSE)
#

require 'rails_helper'

describe League, type: :model do
  subject(:league) { create(:league) }

  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  it { is_expected.to have_many :seasons }
end
