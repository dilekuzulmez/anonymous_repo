class CreatePaymentService
  CREATE_ORDER = ENV['CREATE_ORDER']
  REDIRECT = 'https://' + ENV['APPLICATION_HOST'] + '/api/complete_purchase'.freeze

  # rubocop:disable all
  def initialize(payment, customer)
    @customer = customer
    @payment = payment
  end

  def execute
    JSON.parse(request.body)
  end

  private

  def request
    HTTParty.post(CREATE_ORDER, query: generate_query, headers: headers)
  end

  def headers
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  def generate_query
    if generate_campaign(@payment).nil? 
      {
        mTransactionID: @payment.key,
        merchantCode: ENV['123PAY_MERCHANT_CODE'],
        bankCode: '123PAY',
        totalAmount: round_amount(@payment.amount),
        clientIP: @payment.request_ip,
        custGender: 'U',
        cancelURL: REDIRECT,
        redirectURL: REDIRECT,
        errorURL: REDIRECT,
        passcode: ENV['123PAY_PASS_CODE'],
        checksum: checksum
      }
    else
      {
        mTransactionID: @payment.key,
        merchantCode: ENV['123PAY_MERCHANT_CODE'],
        bankCode: '123PAY',
        totalAmount: round_amount(@payment.amount),
        clientIP: @payment.request_ip,
        custGender: 'U',
        cancelURL: REDIRECT,
        redirectURL: REDIRECT,
        errorURL: REDIRECT,
        passcode: ENV['123PAY_PASS_CODE'],
        checksum: checksum,
        addInfo: (generate_campaign(@payment)).to_json
      }
    end
  end

  def generate_campaign(payment)
    campaigns = Campaign.active_123p
    return nil if campaigns.size == 0
  
    campaign = find_campaign(payment, campaigns)
    return nil unless campaign

    return_campaign(campaign)
  end

  def find_campaign(payment, campaigns)
    if campaigns.size == 1
      campaigns.first
    else
      campaign = if payment.order.promotion_code&.empty?
        campaigns.detect { |c| c.used_with_promotion == false }       
      else
        campaigns.detect { |c| c.used_with_promotion == true }       
      end
    end
  end

  def return_campaign(campaign)
    {
      promotion: {
        CAMPAIGNID: campaign.code.upcase
      }
    }
  end

  def round_amount(amount)
    format('%.0f', amount)
  end

  def checksum
    sum = @payment.key +
          ENV['123PAY_MERCHANT_CODE'] +
          '123PAY' +
          round_amount(@payment.amount) +
          @payment.request_ip +
          'U' +
          REDIRECT * 3 +
          ENV['123PAY_PASS_CODE'] +
          ENV['123PAY_SECRET_KEY']
    Digest::SHA1.hexdigest(sum)
  end
end
