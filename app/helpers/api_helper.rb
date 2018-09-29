module ApiHelper
  include ExceptionsHelper
  def full_profile?(hash = {})
    hash = hash.except('access_token', 'favorite_team_id', 'push_token', 'referral_code',
                       'profile_image_url', 'gender', 'invitor_code')

    return false unless full_address?(hash)

    hash.each_value do |v|
      return false if v.blank?
    end

    true
  end

  def full_address?(hash = {})
    return false if hash['address'].blank? ||
                    hash['address']['city'].blank? ||
                    hash['address']['street'].blank? ||
                    hash['address']['district'].blank?
    true
  end

  def to_currency(num)
    ActionController::Base.helpers.number_to_currency(num, precision: 0, unit: 'VND', format: '%n %u')
  end
end
