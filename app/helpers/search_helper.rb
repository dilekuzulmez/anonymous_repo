module SearchHelper
  def calculate_income(orders)
    total = 0
    orders.each do |order|
      total += order.total_after_discount
    end
    total
  end
end
