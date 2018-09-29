# frozen_string_literal: true

module OrdersHelper
  def render_discount(order)
    return if order.promotion_code.blank?

    discount_amount = case order.discount_type
                      when 'percent'
                        "#{order.discount_amount} %"
                      when 'amount'
                        in_currency_format(order.discount_amount)
                      end

    "#{order.promotion_code} (discount: #{discount_amount})"
  end

  # rubocop:disable all
  def order_custom_hash(order)
    transaction_history = TransactionHistory.find_by(order_id: order.id)
    customer_link = guard_link(order.customer) { link_to order.customer.name, customer_path(order.customer) }
    if transaction_history
      opamount = transaction_history.opamount ||= order.total_after_discount
      discount = transaction_history.discount_amount_123 ||= 0
    else
      discount = 0
      opamount = order.total_after_discount
    end

    transactionID = if order.transaction_history&.response.present?
      if order.transaction_history&.response.dig('123PAYtransactionId').present?
        order.transaction_history&.response.dig('123PAYtransactionId')
      else
        order.transaction_history&.response.dig('mTransactionID')
      end
    end
    {
      customer: customer_link,
      total_before_discount: in_currency_format(order.total_before_discount),
      total_after_discount: in_currency_format(order.total_after_discount),
      discount_in_123_pay: discount,
      final_payment: in_currency_format(opamount),
      # transaction_ID: transactionID
    }
  end

  def order_detail_custom_hash(detail)
    {
      ticket_type: link_to(detail.ticket_type.code, match_ticket_type_path(detail.match, detail.ticket_type)),
      unit_price: in_currency_format(detail.unit_price),
      match: link_to(detail.match.name, match_path(detail.match)),
      qr_code: image_tag(detail.qr_code_file_name, size: '100')
    }
  end
end
