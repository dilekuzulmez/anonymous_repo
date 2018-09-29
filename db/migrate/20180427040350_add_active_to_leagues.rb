class AddActiveToLeagues < ActiveRecord::Migration[5.1]
  def change
    add_column :leagues, :active, :boolean, default: false
  end
end
