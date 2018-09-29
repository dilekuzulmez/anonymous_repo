# == Schema Information
#
# Table name: combos
#
#  id          :integer          not null, primary key
#  code        :string
#  ticket_type :string
#  description :text
#  price       :decimal(, )
#  is_active   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Combo, type: :model do
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_presence_of :ticket_type }
  it { is_expected.to validate_presence_of :price }
  it { is_expected.to have_many :matches }
end
