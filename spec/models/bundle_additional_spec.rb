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

require 'rails_helper'

RSpec.describe BundleAdditional, type: :model do
  it { is_expected.to belong_to :ticket_type }

  it { is_expected.to validate_presence_of(:ticket_type_id) }
  it { is_expected.to validate_presence_of(:home_team_id) }
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
end
