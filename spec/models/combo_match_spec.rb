# == Schema Information
#
# Table name: combos_matches
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  combo_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_combos_matches_on_combo_id  (combo_id)
#  index_combos_matches_on_match_id  (match_id)
#
# Foreign Keys
#
#  fk_rails_...  (combo_id => combos.id)
#  fk_rails_...  (match_id => matches.id)
#

require 'rails_helper'

RSpec.describe ComboMatch, type: :model do
  it { is_expected.to belong_to :combo }
  it { is_expected.to belong_to :match }
end
