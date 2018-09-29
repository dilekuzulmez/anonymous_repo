class PushUnpaidOrderJob < ApplicationJob
  queue_as :default

  # rubocop:disable Metrics/LineLength
  def perform(order)
    return if order.paid? || order.expired_at < Time.current
    customer = order.customer
    title = 'Thanh toán vé'
    body = 'Đơn hàng của bạn gần hết thời gian thanh toán, bạn hay đến địa chỉ văn phòng để thanh toán COD hoặc chuyển đổi thanh toán bằng hình thức Online/ đổi điểm. Nếu quá thời gian qui định đơn hàng của bạn sẽ bị hủy'
    NotificationsService.new([customer]).send_notifications(title, body)
    SaveNotiService.new(title, body, [customer], true).execute
  end
end
