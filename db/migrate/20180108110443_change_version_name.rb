class ChangeVersionName < ActiveRecord::Migration[5.1]
  def change
    rename_column :versions, :version, :number
  end
end
