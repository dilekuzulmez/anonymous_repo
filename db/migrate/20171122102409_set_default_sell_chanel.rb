class SetDefaultSellChanel < ActiveRecord::Migration[5.1]
  def up
    change_column :orders, :sale_channel, :string, :default => 'COD'
  end
end
