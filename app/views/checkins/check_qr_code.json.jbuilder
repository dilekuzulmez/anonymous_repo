json.id @detail.id
json.customer_name @detail.order.customer.name
json.order_id @detail.order_id
json.ticket_type @detail.ticket_type.code
json.quantity @detail.quantity
json.order_price @detail.order.total_after_discount
json.paid @detail.order.paid
