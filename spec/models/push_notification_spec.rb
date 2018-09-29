# == Schema Information
#
# Table name: push_notifications
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe PushNotification, type: :model do
  it { is_expected.to validate_presence_of :body }
end
