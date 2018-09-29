class AddPaymentInfoToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :payment_info_vi, :text
    add_column :teams, :payment_info_en, :text
  end
end
