class FirstTicketService
  def initialize(order)
    @order = order
    @customer = @order&.customer
    @invitor = Customer.find_by(referral_code: @customer&.invitor_code)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def execute
    return false unless @order && @invitor.present? && @customer.orders.count <= 1
    return false unless @order.status.completed?
    @ftk = LoyaltyPointRule.find_by(code: 'FTK', active: true)
    return false unless add_point_to_both && push_notification
    true
  end

  private

  def add_point_to_both
    @invitor.point += @ftk.point
    @customer.point += @ftk.point
    return true if @invitor.save! && @customer.save! && save_point_history
    false
  end

  # rubocop:disable Metrics/LineLength
  def save_point_history
    st_record = @invitor.history_points.new(loyalty_point_rule_id: @ftk.id, point: @ftk.point,
                                            name: "#{@customer.name} purchased 1st ticket . You earned some points")
    nd_record = @customer.history_points.new(loyalty_point_rule_id: @ftk.id, point: @ftk.point, name: @ftk.name)
    return true if st_record.save!(validate: false) && nd_record.save!(validate: false)
    false
  end

  def push_notification
    mess = "Congratulations ! You just earned #{@ftk.point} points"
    invite_mess = "#{@customer.name} purchased first ticket"
    purchase_mess = 'Purchased first ticket'
    SaveNotiService.new(purchase_mess, mess, [@customer], true).execute if NotificationsService.new([@customer.id]).send_notifications(purchase_mess, mess)
    SaveNotiService.new(invite_mess, mess, [@invitor], true).execute if NotificationsService.new([@invitor.id]).send_notifications(invite_mess, mess)
    true
  end
end
