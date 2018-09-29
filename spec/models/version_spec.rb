# == Schema Information
#
# Table name: versions
#
#  id          :integer          not null, primary key
#  number      :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  os          :integer
#

require 'rails_helper'

RSpec.describe Version, type: :model do
  it { is_expected.to validate_presence_of(:os) }
  it { is_expected.to allow_value('1.3.4').for(:number) }
end
