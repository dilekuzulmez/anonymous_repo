# == Schema Information
#
# Table name: advertisements
#
#  id                 :integer          not null, primary key
#  promotion_id       :integer
#  title              :string
#  duration           :daterange
#  description        :text
#  active             :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  priority           :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Advertisement, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :duration }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to belong_to :promotion }
end
