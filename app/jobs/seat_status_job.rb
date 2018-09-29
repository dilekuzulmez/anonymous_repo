class SeatStatusJob < ApplicationJob
  SEAT_END_POINT = ENV['SEAT_API_ENDPOINT'] + '/api/v1/match/seat'
  queue_as :default

  def perform(order, create_order = false)
    return if order.seat_ids.empty?
    request_enable_seat(order, 'ordered') && return if create_order
    request_enable_seat(order, 'enable') unless order.paid?
    request_enable_seat(order, 'complete') if order.paid?
  end

  private

  def request_enable_seat(order, status)
    json_body = { 'seats': order.seat_ids }.to_json
    response = HTTParty.post("#{SEAT_END_POINT}?status=" + status,
                             body: json_body,
                             headers: { 'Content-Type' => 'application/json' })
    response.success?
  end
end
