class AddImageToBundleAdditional < ActiveRecord::Migration[5.1]
  def change
    add_attachment :bundle_additionals, :banner
  end
end
