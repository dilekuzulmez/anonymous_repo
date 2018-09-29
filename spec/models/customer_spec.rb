# == Schema Information
#
# Table name: customers
#
#  id           :integer          not null, primary key
#  email        :string
#  first_name   :string
#  last_name    :string
#  gender       :string(32)
#  birthday     :date
#  phone_number :string(32)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  address      :hstore
#
# Indexes
#
#  index_customers_on_email_and_phone_number  (email,phone_number) UNIQUE
#

require 'rails_helper'

RSpec.describe Customer, type: :model do
  subject { create(:customer) }

  it { is_expected.to have_many(:orders) }
end
