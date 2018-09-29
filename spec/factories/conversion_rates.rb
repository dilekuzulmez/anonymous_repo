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

FactoryGirl.define do
  factory :conversion_rate do
    code 'P2M'
    description '10k 1 point'
    money 10_000
    point 1
  end
end
