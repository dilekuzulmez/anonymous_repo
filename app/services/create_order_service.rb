class CreateOrderService
  include SeasonsHelper

  def initialize(order)
    @order = order
  end

  # rubocop:disable Metrics/AbcSize
  def execute
    # early return before merging details
    create_season_order if @order.home_team_id

    return false unless @order.valid?

    # Avoid Postman send request from anonymous with different unit price
    return false if @order.order_details.first.ticket_type.price != @order.order_details.first.unit_price
    merge_order_details unless @order.order_details.first.match.home_team_id

    @order.calculate_expired_at
    @order.save
    update_promotion
    PushUnpaidOrderJob.set(wait_until: @order.expired_at - 10.hours).perform_later(@order)
    @order
  end

  private

  def merge_order_details
    order_details = @order.order_details || []

    group_hash = order_details.each_with_object({}) do |detail, hash|
      if hash[detail.ticket_type_id]
        hash[detail.ticket_type_id].quantity += detail.quantity
      else
        hash[detail.ticket_type_id] = detail
      end
    end

    @order.order_details = group_hash.values
  end

  def order_detail_params_for_season_order(match, zone)
    order_detail = OrderDetail.new
    order_detail.quantity = @order.order_details.first.quantity

    ticket_type = match.ticket_types.find_by(zone: zone)
    order_detail.ticket_type = ticket_type

    order_detail.unit_price = order_detail.ticket_type.price
    order_detail.match = match
    order_detail
  end

  def update_promotion
    promotion = @order.promotion
    return unless promotion
    customer_promotion = CustomersPromotion.find_or_create_by(promotion: @order.promotion,
                                                              customer: @order.customer)
    customer_promotion.update_attributes(number_used: customer_promotion.number_used + 1)
    # update quantity of promotion if that promotion is limit
    @order.promotion.update_attributes(quantity: promotion.quantity - 1) if promotion.quantity
  end
end
