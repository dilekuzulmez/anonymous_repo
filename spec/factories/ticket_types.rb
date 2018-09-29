# == Schema Information
#
# Table name: ticket_types
#
#  id         :integer          not null, primary key
#  match_id   :integer          not null
#  zone_id    :integer
#  quantity   :integer          not null
#  code       :string           not null
#  slug       :string
#  price      :decimal(, )      default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  class_type :integer          default(NULL), not null
#
# Indexes
#
#  index_ticket_types_on_match_id           (match_id)
#  index_ticket_types_on_match_id_and_code  (match_id,code) UNIQUE
#  index_ticket_types_on_slug               (slug) UNIQUE
#  index_ticket_types_on_zone_id            (zone_id)
#
# Foreign Keys
#
#  fk_rails_...  (match_id => matches.id)
#  fk_rails_...  (zone_id => zones.id)
#

FactoryGirl.define do
  factory :ticket_type do
    association :zone, factory: :zone

    code { zone&.code }
    price { zone&.price }
    quantity { zone&.capacity }

    before(:create) do |ticket_type, evaluator|
      match = evaluator.match || create(:match, stadium: ticket_type.zone.stadium)
      ticket_type.match = match
    end
  end
end
