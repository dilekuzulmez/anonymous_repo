class ChangeVersionOsEnum < ActiveRecord::Migration[5.1]
  def change
    change_column :versions, :os, 'integer USING CAST(os AS integer)'
  end
end
