# == Schema Information
#
# Table name: gates
#
#  id         :integer          not null, primary key
#  code       :string           not null
#  slug       :string
#  stadium_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_gates_on_code_and_stadium_id  (code,stadium_id) UNIQUE
#  index_gates_on_slug                 (slug) UNIQUE
#  index_gates_on_stadium_id           (stadium_id)
#
# Foreign Keys
#
#  fk_rails_...  (stadium_id => stadiums.id)
#

require 'rails_helper'

RSpec.describe Gate, type: :model do
  subject(:gate) { create(:gate) }

  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_uniqueness_of(:code).scoped_to(:stadium_id).case_insensitive }
  it { is_expected.to normalize_attribute(:code).from('abc').to('ABC') }

  it { is_expected.to belong_to :stadium }
  it { is_expected.to have_many :zones }
end
