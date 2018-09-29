class CreateSurveys < ActiveRecord::Migration[5.1]
  def change
    create_table :surveys do |t|
      t.string :name
      t.string :link
      t.text :description
      t.boolean :active

      t.timestamps
    end
  end
end
