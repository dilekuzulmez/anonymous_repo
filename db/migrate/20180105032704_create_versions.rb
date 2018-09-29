class CreateVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :versions do |t|
      t.float :version
      t.text :description

      t.timestamps
    end
  end
end
