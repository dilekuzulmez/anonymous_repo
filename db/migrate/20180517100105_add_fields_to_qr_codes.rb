class AddFieldsToQrCodes < ActiveRecord::Migration[5.1]
  def change
    add_column :qr_codes, :home_team_id, :integer
    add_column :qr_codes, :ticket_type, :string
    add_column :qr_codes, :channel, :string
    add_column :qr_codes, :created_at, :datetime
    add_column :qr_codes, :updated_at, :datetime
  end
end
