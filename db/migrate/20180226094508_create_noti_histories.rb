class CreateNotiHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :noti_histories do |t|
      t.references :customer, foreign_key: true
      t.string :title
      t.string :body
      t.boolean :status, default: false
      t.boolean :seen, default: false

      t.timestamps
    end
  end
end
