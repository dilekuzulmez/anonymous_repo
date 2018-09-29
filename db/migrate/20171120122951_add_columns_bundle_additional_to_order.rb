class AddColumnsBundleAdditionalToOrder < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :bundle_additional, foreign_key: true
  end
end
