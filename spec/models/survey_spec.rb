# == Schema Information
#
# Table name: surveys
#
#  id          :integer          not null, primary key
#  name        :string
#  link        :string
#  description :text
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Survey, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of :link }
  it { is_expected.to validate_uniqueness_of(:link) }
  it { is_expected.to validate_length_of(:name).is_at_most(100).with_message('Name is too long.') }
end
