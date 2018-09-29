class AddExpiration < ActiveRecord::Migration[5.1]
  def up
    add_column :qr_codes, :expired_at, :datetime
  end

  def down
    remove_column :qr_codes, :expired_at, :datetime
  end
end
