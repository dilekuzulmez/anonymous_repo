class AddAttachmentBannerToTeams < ActiveRecord::Migration[5.1]
  def self.up
    change_table :teams do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :teams, :banner
  end
end
