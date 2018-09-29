class AddColumnToVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :versions, :os, :string
    change_column :versions, :version, :string
  end
end
