class QueryPaymentService
  QUERY_ORDER = ENV['QUERY_ORDER']

  # rubocop:disable all
  def initialize(payment)
    @payment = payment
  end

  def execute
    JSON.parse(request.body)
  end

  private

  def request
    HTTParty.post(QUERY_ORDER, query: query, headers: headers)
  end

  def headers
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  def query
    {
      mTransactionID: @payment.key,
      merchantCode: ENV['123PAY_MERCHANT_CODE'],
      clientIP: @payment.request_ip,
      passcode: ENV['123PAY_PASS_CODE'],
      checksum: checksum,
    }
  end

  def checksum
    sum = @payment.key +
          ENV['123PAY_MERCHANT_CODE'] +
          @payment.request_ip +
          ENV['123PAY_PASS_CODE'] +
          ENV['123PAY_SECRET_KEY']
    Digest::SHA1.hexdigest(sum)
  end
end
