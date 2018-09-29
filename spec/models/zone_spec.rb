# == Schema Information
#
# Table name: zones
#
#  id          :integer          not null, primary key
#  code        :string           not null
#  description :string
#  capacity    :integer          default(0), not null
#  price       :decimal(, )      default(0.0), not null
#  slug        :string
#  stadium_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  zone_type   :integer          default("Standard"), not null
#
# Indexes
#
#  index_zones_on_code_and_stadium_id  (code,stadium_id) UNIQUE
#  index_zones_on_slug                 (slug) UNIQUE
#  index_zones_on_stadium_id           (stadium_id)
#
# Foreign Keys
#
#  fk_rails_...  (stadium_id => stadiums.id)
#

require 'rails_helper'

describe Zone, type: :model do
  subject(:zone) { create(:zone) }

  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_presence_of :capacity }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to validate_uniqueness_of(:code).scoped_to(:stadium_id).case_insensitive }
  it { is_expected.to normalize_attribute(:code).from('abc').to('ABC') }

  it { is_expected.to belong_to :stadium }
  it { is_expected.to belong_to :gate }
end
