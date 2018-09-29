class CreateIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :identities do |t|
      t.string :uid
      t.string :provider
      t.belongs_to :customer, index: true, foreign_key: true

      t.timestamps
    end
  end
end
