class QrOrderService
  def initialize(match, qr)
    @match = match
    @qr = qr
    @customer = @qr.channel == 'MB' ? Customer.find_by(email: 'mb@bank.com') : ''
  end

  # rubocop:disable all
  def create_order
    return unless @match && @qr && @customer.present?
    ticket_type = @match.ticket_types.where(code: @qr.ticket_type).first
    return unless ticket_type
    @order = Order.new(customer: @customer, sale_channel: @qr.channel, paid: true, status: :completed)
    @order_detail = @order.order_details.new(match: @match, ticket_type: ticket_type, quantity: 1, unit_price: ticket_type.price)
  end

  def update_qr
    return unless @order_detail.save! && @order.save!
    @qr.update(order_detail: @order_detail, match: @match, customer: @customer, used: true)
  end
end
