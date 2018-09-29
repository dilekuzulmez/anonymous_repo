class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.belongs_to :admin, index: true
      t.timestamp :viewed_at
      t.string :kind, limit: 16
      t.string :message
      t.string :target
      t.timestamps
    end
  end
end
