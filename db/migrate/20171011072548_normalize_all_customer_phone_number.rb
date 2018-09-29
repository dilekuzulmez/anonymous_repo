class NormalizeAllCustomerPhoneNumber < ActiveRecord::Migration[5.1]
  def change
    Customer.all.each do |customer|
      customer.update_columns(phone_number: customer.phone_number.phony_normalized)
    end
  end
end
