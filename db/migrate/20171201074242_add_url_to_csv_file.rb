class AddUrlToCsvFile < ActiveRecord::Migration[5.1]
  def change
    add_column :csv_files, :url, :string
  end
end
