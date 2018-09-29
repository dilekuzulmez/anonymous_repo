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

class Customer < ApplicationRecord
  devise :omniauthable, :trackable, omniauth_providers: [:google_oauth2]
  extend Enumerize
  audited

  validates :email, format: { with: Devise.email_regexp }, if: :email, uniqueness: true
  normalize_attribute :email, with: :downcase

  enumerize :gender, in: %i[male female other]

  has_many :orders

  def name
    [first_name, last_name].compact.join(' ')
  end

  def update_from_oauth(auth)
    auth_info = auth.info

    update_attributes!(
      first_name: auth_info.first_name,
      last_name: auth_info.last_name,
    )
  end

  def self.find_user_info(info)
    info[0] = '' if info[0] == '0'
    where('email ILIKE ? or phone_number ILIKE ?', "#{info}%", "%#{info}")
  end
end
