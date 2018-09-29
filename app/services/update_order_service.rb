class UpdateOrderService
  attr_reader :order

  def initialize(order, update_params)
    @order = order
    update_params[:purchased_date] = Time.current if update_params[:paid]
    @order.assign_attributes(update_params)
    @order.assign_attributes(purchased_date: Time.current) if update_params[:paid].present?
  end

  def execute
    return unless @order.valid?

    @order.calculate_expired_at
    @order.save
  end
end
