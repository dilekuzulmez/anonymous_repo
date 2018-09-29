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

FactoryGirl.define do
  factory :push_notification do
    title 'Title'
    body 'Body'
  end
end
