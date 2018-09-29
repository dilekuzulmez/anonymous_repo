# == Schema Information
#
# Table name: matchs_promotions
#
#  id           :integer          not null, primary key
#  match_id     :integer
#  promotion_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_matchs_promotions_on_match_id      (match_id)
#  index_matchs_promotions_on_promotion_id  (promotion_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (promotion_id => promotions.id)
#

class MatchsPromotion < ApplicationRecord
  belongs_to :match
  belongs_to :promotion
end
