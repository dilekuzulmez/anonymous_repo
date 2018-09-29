# == Schema Information
#
# Table name: conversion_rates
#
#  id          :integer          not null, primary key
#  code        :integer
#  description :text
#  money       :integer
#  point       :integer
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe ConversionRate, type: :model do
  it { is_expected.to validate_presence_of :code }
  it { is_expected.to validate_presence_of :money }
  it { is_expected.to validate_presence_of :point }
end
