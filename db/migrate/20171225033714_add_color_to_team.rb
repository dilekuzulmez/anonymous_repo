class AddColorToTeam < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :code, :string
    add_column :teams, :color_1, :string
    add_column :teams, :color_2, :string
  end
end
