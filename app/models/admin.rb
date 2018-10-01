# == Schema Information
#
# Table name: admins
#
#  id                 :integer          not null, primary key
#  email              :string           not null
#  uid                :string
#  provider           :string
#  first_name         :string
#  last_name          :string
#  profile_image_url  :string
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :inet
#  last_sign_in_ip    :inet
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  created_by_id      :integer
#  employee_token     :string
#  token_expire       :datetime
#  encrypted_password :string           default(""), not null
#
# Indexes
#
#  index_admins_on_created_by_id  (created_by_id)
#  index_admins_on_email          (email) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => admins.id)
#

class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable

  validates_presence_of :email
  validates_format_of :email, with: Devise.email_regexp
  validates_uniqueness_of :email

  audited

  def update_from_oauth(auth)
    auth_info = auth.info

    update_attributes!(
      provider: auth.provider,
      uid: auth.uid,
      first_name: auth_info.first_name,
      last_name: auth_info.last_name,
      profile_image_url: auth_info.image,
      token_expire: Time.now + 2.days,
      employee_token: auth.credentials.token
    )
  end

  def created_by
    Admin.find_by(id: created_by_id)
  end

  def name
    [first_name, last_name].compact.join(' ')
  end

  def activated?
    uid.present?
  end
end
