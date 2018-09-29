class RemoveCustomerDuplicated < ActiveRecord::Migration[5.1]
  def change
    remove_column :customers, :profile_picture_url
  end
end
