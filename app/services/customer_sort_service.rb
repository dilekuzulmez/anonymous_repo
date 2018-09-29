class CustomerSortService
  def sort_by_spending
    Customer.all.sort_by do |customer|
      customer.orders.includes(:order_details).by_paid(true).map(&:total_after_discount).sum
    end.reverse
  end
end
