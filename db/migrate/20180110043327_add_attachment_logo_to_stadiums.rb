class AddAttachmentLogoToStadiums < ActiveRecord::Migration[5.1]
  def self.up
    change_table :stadiums do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :stadiums, :logo
  end
end
