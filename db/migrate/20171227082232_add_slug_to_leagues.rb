class AddSlugToLeagues < ActiveRecord::Migration[5.1]
  def change
    add_column :leagues, :slug, :string
  end
end
