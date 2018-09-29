class PushRemindMessageWorker
  include Sidekiq::Worker
  include ActionView::Helpers::NumberHelper
  require 'rest-client'

  @host = 'https://fcm.googleapis.com/fcm/send'

  def perform(order_id, price)
    return if Order.find(order_id).paid
    @total_price = price
    @push_token = Customer.push_token order_id
    RestClient.post(@host, data(id), request_header) unless @push_token.nil?
  end

  private

  def data(id)
    {
      to: @push_token,
      notification: {
        title: 'Unpaid Order',
        body: message
      },
      data: {
        order_id: id
      }
    }.to_json
  end

  def request_header
    {
      Authorization: "key=#{ENV['FIRE_BASE_KEY']}",
      content_type: :json,
      accept: :json
    }
  end

  def message
    price = in_currency_format(@total_price)
    template = File.read(Rails.root.join('lib/assets/unpaid_order_message_template'))
    ERB.new(HTMLEntities.new.decode(template)).result(binding)
  end

  def in_currency_format(value)
    value ? number_to_currency(value, precision: 0, unit: 'VND', delimiter: ',', format: '%u %n') : ''
  end
end
