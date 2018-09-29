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

FactoryGirl.define do
  factory :gate do
    sequence(:code) { |n| "gate_#{n}" }

    association :stadium, factory: :stadium
  end
end
