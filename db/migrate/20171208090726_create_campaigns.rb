class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.string :code, requried: true, null: false
      t.boolean :used_with_promotion, null: false, default: false
      t.boolean :is_active, null: false, default: false
      t.timestamps
    end
  end
end
