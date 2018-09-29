# == Schema Information
#
# Table name: bundle_additionals
#
#  id                  :integer          not null, primary key
#  code                :string
#  description         :string
#  price               :decimal(, )      default(0.0), not null
#  is_active           :boolean          default(FALSE), not null
#  ticket_type_id      :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  banner_file_name    :string
#  banner_content_type :string
#  banner_file_size    :integer
#  banner_updated_at   :datetime
#  home_team_id        :integer
#  league_id           :integer
#
# Indexes
#
#  index_bundle_additionals_on_ticket_type_id  (ticket_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (ticket_type_id => ticket_types.id)
#

FactoryGirl.define do
  factory :bundle_additional do
    code  { Faker::Name.first_name }
    price { rand(1..100) }
    ticket_type { create(:ticket_type) }
    association :home_team, factory: :team
    is_active true
  end
end
